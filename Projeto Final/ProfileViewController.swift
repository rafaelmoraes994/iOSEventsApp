//
//  ProfileViewController.swift
//  ProjetoFinal
//
//  Created by Rafael on 5/21/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit
import KeepLayout

extension UIColor{
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, EventObserver, LoginDelegate {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var loginView: LoginViewController!
    
    var selectedCell: Int = 0
    
    var favoriteEventsArray: [Event] = [] {
        didSet{
            profileCollectionView.reloadData()
        }
    }
    
    var confirmedEventsArray: [Event] = [] {
        didSet{
            profileCollectionView.reloadData()
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        self.view.addSubview(loginView.view)
        loginView.view.keep(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        addChildViewController(loginView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventController.shared.observerArray.append(self)
        
        favoriteEventsArray = EventController.shared.findFavoriteEvents()
        
        confirmedEventsArray = EventController.shared.findConfirmedEvents()
        
        profileTableView.contentInset.top = 16
        
        loginView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        
        self.view.addSubview(loginView.view)
        loginView.view.keep(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        addChildViewController(loginView)
        loginView.loginDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = self.logoutButton
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        profileTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionCell", for: indexPath) as! ProfileCollectionViewCell
        
        switch indexPath.row {
        case 1:
            cell.cellImage.image = UIImage(named: "favoriteIcon")?.withRenderingMode(.alwaysTemplate)
            cell.cellLabel.text = "\(favoriteEventsArray.count)"
        case 2:
            cell.cellImage.image = UIImage(named: "historyIcon")?.withRenderingMode(.alwaysTemplate)
            cell.cellLabel.text = "0"
        default:
            cell.cellImage.image = UIImage(named: "eventIcon")?.withRenderingMode(.alwaysTemplate)
            cell.cellLabel.text = "\(confirmedEventsArray.count)"
        }
        
        if(indexPath.row == selectedCell){
            cell.cellImage.tintColor = UIColor.magenta
            cell.cellLabel.textColor = UIColor.magenta
            cell.layer.backgroundColor = UIColor.black.lighter(by: 20)?.withAlphaComponent(0.7).cgColor
        }else{
            cell.cellImage.tintColor = UIColor.white
            cell.cellLabel.textColor = UIColor.white
            cell.layer.backgroundColor = UIColor.black.cgColor
        }
        
        cell.tintColor = UIColor.white
        cell.layer.cornerRadius = 20
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        self.profileCollectionView.reloadData()
        self.profileTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-140)/3, height: collectionView.frame.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedCell {
        case 0:
            return confirmedEventsArray.count
        case 1:
            return favoriteEventsArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 317
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("EventsTableViewCell", owner: self, options: nil)?.first as! EventsTableViewCell
        
        switch selectedCell {
        case 0:
            cell.event = confirmedEventsArray[indexPath.row]
        case 1:
            cell.event = favoriteEventsArray[indexPath.row]
        default:
            return cell
        }
        
        cell.updateBlock = {
            EventController.shared.didUpdateEvents(sender: self)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let eventDescription = storyboard?.instantiateViewController(withIdentifier: "EventDescription") as? EventDescriptionViewController {
            
            switch selectedCell {
            case 0:
                eventDescription.event = confirmedEventsArray[indexPath.row]
            case 1:
                eventDescription.event = favoriteEventsArray[indexPath.row]
            default:
                eventDescription.event = nil
            }
            
            self.navigationController?.pushViewController(eventDescription, animated: true)
        }
    }
    
    func didUpdateEvents(sender: EventObserver?) {
        favoriteEventsArray = EventController.shared.findFavoriteEvents()
        confirmedEventsArray = EventController.shared.findConfirmedEvents()
        if(sender === self){
            return
        }
        profileTableView.reloadData()
    }

    func didFinishLogin() {
        self.tabBarController?.navigationItem.rightBarButtonItem = self.logoutButton
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }

}
