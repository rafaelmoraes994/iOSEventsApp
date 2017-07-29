//
//  EventViewController.swift
//  ProjetoFinal
//
//  Created by Rafael on 5/23/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit
import Floaty

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EventObserver {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var closeSearchTapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var camouflageView: UIView!

    @IBOutlet weak var createEventButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var lastOffsetY :CGFloat = 0
    
    var selectedCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventController.shared.observerArray.append(self)
        
        self.tabBarController?.navigationItem.leftBarButtonItem = filterButton
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        
        self.edgesForExtendedLayout = []
        tableView.contentInset.top = 16
        
        createEventButton.layer.cornerRadius = 30
        createEventButton.layer.backgroundColor = UIColor.purple.cgColor
        createEventButton.setImage(UIImage( named: "plusIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        createEventButton.tintColor = UIColor.white
        createEventButton.clipsToBounds = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = filterButton
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        tableView.reloadData()
    }

    
    @IBAction func openFilter(_ sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        //present(FilterSettingsViewController(), animated: false, completion: nil)
        
    }
    
    
    @IBAction func showSearch(_ sender: UIBarButtonItem) {
        
        self.camouflageView.isHidden = false
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
            self.tabBarController?.navigationItem.rightBarButtonItem = self.searchButton
            self.tabBarController?.navigationItem.leftBarButtonItem = self.filterButton
            self.camouflageView.isHidden = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EventController.shared.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 317
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("EventsTableViewCell", owner: self, options: nil)?.first as! EventsTableViewCell
        
        cell.event = EventController.shared.filteredArray[indexPath.row]
        
        cell.updateBlock = {
            EventController.shared.didUpdateEvents(sender: self)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let eventDescription = storyboard?.instantiateViewController(withIdentifier: "EventDescription") as? EventDescriptionViewController {
            
            eventDescription.event = EventController.shared.filteredArray[indexPath.row]
            
            self.navigationController?.pushViewController(eventDescription, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCollectionCell", for: indexPath) as! EventCollectionViewCell
        
        switch indexPath.row {
        case 1:
            cell.cellLabel.text = "Weekend"
        case 2:
            cell.cellLabel.text = "Week"
        case 3:
            cell.cellLabel.text = "Custom"
        default:
            cell.cellLabel.text = "Today"
        }
        
        if(indexPath.row == selectedCell){
            cell.cellLabel.textColor = UIColor.magenta
        }else{
            cell.cellLabel.textColor = UIColor.white
        }
        
        cell.tintColor = UIColor.white
        cell.layer.cornerRadius = 20
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-40)/4, height: collectionView.frame.height)
    }

    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        lastOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let hide = scrollView.contentOffset.y > self.lastOffsetY
        
        if hide{
            UIView.animate(withDuration: 0.6, animations: {
                self.createEventButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.createEventButton.alpha = 0
            })
        } else{
            UIView.animate(withDuration: 0.6, animations: {
                self.createEventButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.createEventButton.alpha = 1
            })
        }

    }
    
    func didUpdateEvents(sender: EventObserver?) {
        if(sender === self){
            return
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var filterEvent: [Event] = []
        
        for event in EventController.shared.eventsArray {
            if (event.name.contains(searchBar.text!)) || (event.address.contains(searchBar.text!)) || (event.tags.contains(searchBar.text!)){
                filterEvent.append(event)
            }
        }
        EventController.shared.filteredArray = filterEvent
        EventController.shared.didUpdateEvents(sender: nil)
        searchBar.resignFirstResponder()
    }
    
}







