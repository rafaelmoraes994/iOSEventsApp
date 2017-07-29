//
//  FilterSettingsViewController.swift
//  ProjetoFinal
//
//  Created by Rafael on 4/25/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit

class FilterSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var friendsImage: UIImageView!
    
    @IBOutlet weak var distanceImage: UIImageView!
    
    @IBOutlet weak var universityImage: UIImageView!
    
    @IBOutlet weak var partyImage: UIImageView!
    
    @IBOutlet weak var barImage: UIImageView!
    
    @IBOutlet weak var liveMusicImage: UIImageView!

    @IBOutlet weak var resetFilters: UIBarButtonItem!

    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBOutlet weak var friendsSwitch: UISwitch!
    
    @IBOutlet weak var distanceSwitch: UISwitch!
    
    @IBOutlet weak var universitySwitch: UISwitch!
    
    @IBOutlet weak var partySwitch: UISwitch!
    
    @IBOutlet weak var barSwitch: UISwitch!
    
    @IBOutlet weak var musicSwitch: UISwitch!
    
    @IBAction func resetFilters(_ sender: AnyObject) {
        
        favoriteSwitch.isOn = false
        friendsSwitch.isOn = false
        distanceSwitch.isOn = false
        universitySwitch.isOn = false
        partySwitch.isOn = false
        barSwitch.isOn = false
        musicSwitch.isOn = false
    }
    
    
    @IBAction func finishFiltering(_ sender: AnyObject){
        var filterArray: [Event] = []
        
        for event in EventController.shared.eventsArray {
            if favoriteSwitch.isOn && !event.isFavorite {
                continue
            }
            if (universitySwitch.isOn && event.tags.contains("Tag: Universitario")) || (partySwitch.isOn && (event.tags.contains("Tag: Festa") || event.tags.contains("Tag: Boate"))) || (barSwitch.isOn && event.tags.contains("Tag: Bar")) || (musicSwitch.isOn && event.tags.contains("Tag: Musica ao Vivo")) {
                filterArray.append(event)
                continue
            }
            if !universitySwitch.isOn && !partySwitch.isOn && !barSwitch.isOn && !musicSwitch.isOn {
                filterArray.append(event)
            }
            
        }
        EventController.shared.filteredArray = filterArray
        EventController.shared.didUpdateEvents(sender: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteImage.image = UIImage(named: "favoriteIcon")?.withRenderingMode(.alwaysTemplate)
        favoriteImage.tintColor = UIColor.white
        
        friendsImage.image = UIImage(named: "friendsIcon")?.withRenderingMode(.alwaysTemplate)
        friendsImage.tintColor = UIColor.white
        
        distanceImage.image = UIImage(named: "mapIcon")?.withRenderingMode(.alwaysTemplate)
        distanceImage.tintColor = UIColor.white
        
        universityImage.image = UIImage(named: "universityIcon")?.withRenderingMode(.alwaysTemplate)
        universityImage.tintColor = UIColor.white
        
        partyImage.image = UIImage(named: "partyIcon")?.withRenderingMode(.alwaysTemplate)
        partyImage.tintColor = UIColor.white
        
        barImage.image = UIImage(named: "beerIcon")?.withRenderingMode(.alwaysTemplate)
        barImage.tintColor = UIColor.white
        
        liveMusicImage.image = UIImage(named: "musicIcon")?.withRenderingMode(.alwaysTemplate)
        liveMusicImage.tintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = UIColor.purple
            view.textLabel?.backgroundColor = UIColor.clear
            view.textLabel?.textColor = UIColor.white
        }
    }

}
