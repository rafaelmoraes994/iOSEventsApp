//
//  MapView.swift
//  ProjetoFinal
//
//  Created by Rafael on 4/21/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapSearchButton: UIBarButtonItem!
    
    @IBOutlet weak var dateButton: UIBarButtonItem!
    
    @IBOutlet weak var searchCamouflageView: UIView!
    
    @IBOutlet weak var closeSearchTapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var directionButton: UIButton!
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    let locationManager = CLLocationManager()
    var monitoringSignificantLocationChanges = false
    var searchBar: UISearchBar!
    
    
    
    @IBAction func showDirections(_ sender: UIButton) {
        getDirections()
    }
    
    @IBAction func showSearch(_ sender: UIBarButtonItem) {
        
        self.searchCamouflageView.isHidden = false
        self.searchBar.becomeFirstResponder()
        self.closeSearchTapGesture.isEnabled = true
        self.tabBarController?.navigationItem.titleView = searchBar
        searchBar.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
    }
    
    @IBAction func closeSearch(_ sender: AnyObject) {
        self.searchBar.resignFirstResponder()
        self.closeSearchTapGesture.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.frame.origin.x = UIScreen.main.bounds.width
        }) { (completed) in
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.leftBarButtonItem = self.dateButton
            self.tabBarController?.navigationItem.rightBarButtonItem = self.mapSearchButton
            self.searchCamouflageView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directionButton.layer.cornerRadius = 30
        directionButton.layer.backgroundColor = UIColor.purple.cgColor
        directionButton.setImage(UIImage( named: "distanceIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        directionButton.tintColor = UIColor.white
        directionButton.clipsToBounds = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        self.tabBarController?.navigationItem.leftBarButtonItem = dateButton
        self.tabBarController?.navigationItem.rightBarButtonItem = mapSearchButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = dateButton
        self.tabBarController?.navigationItem.rightBarButtonItem = mapSearchButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate.latitude = location.coordinate.latitude
        print(pin.coordinate.latitude)
        pin.coordinate.longitude = location.coordinate.longitude
        print(pin.coordinate.longitude)
        pin.title = "You"
        mapView.addAnnotation(pin)
        
        
        let pin2 = MKPointAnnotation()
        pin2.coordinate.latitude = 37.333
        pin2.coordinate.longitude = -122.05
        pin2.title = "Event"
        mapView.addAnnotation(pin2)
        
        
        let pin3 = MKPointAnnotation()
        pin3.coordinate.latitude = 37.35
        pin3.coordinate.longitude = -122.03
        pin3.title = "Event"
        mapView.addAnnotation(pin3)

        
        let pin4 = MKPointAnnotation()
        pin4.coordinate.latitude = 37.31
        pin4.coordinate.longitude = -122.01
        pin4.title = "Event"
        mapView.addAnnotation(pin4)
//
//        
//        let pin5 = MKPointAnnotation()
//        pin5.coordinate.latitude = location.coordinate.latitude
//        print(pin5.coordinate.latitude)
//        pin5.coordinate.longitude = location.coordinate.longitude
//        print(pin5.coordinate.longitude)
//        pin5.title = "You"
//        mapView.addAnnotation(pin5)
        

        if !monitoringSignificantLocationChanges {
            locationManager.stopUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            monitoringSignificantLocationChanges = true
        }
    }
    
    func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
//        let reuseId = "pin"
//        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView else { return nil }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation.title! == "You" {
            pinView.pinTintColor = UIColor.red
        } else {
            pinView.pinTintColor = UIColor.blue
        }
        
        pinView.canShowCallout = true
        
        return pinView
    }

}

