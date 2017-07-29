//
//  EventDescriptionViewController.swift
//  ProjetoFinal
//
//  Created by Rafael on 5/1/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit

class EventDescriptionViewController: UITableViewController {
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var dateIcon: UIImageView!

    @IBOutlet weak var addressIcon: UIImageView!
    
    @IBOutlet weak var menIcon: UIImageView!
    
    @IBOutlet weak var womanIcon: UIImageView!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventAddress: UILabel!
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    var event: Event?
    
    @IBAction func confirmEvent(_ sender: AnyObject) {
        if event != nil {
            if(event?.isConfirmed == true){
                event?.isConfirmed = false
                confirmButton.tintColor = UIColor.white
            } else{
                event?.isConfirmed = true
                confirmButton.tintColor = UIColor.magenta
            }
            EventController.shared.didUpdateEvents(sender: nil)
        }
    }
    
    @IBAction func favoriteEvent(_ sender: AnyObject) {
        if event != nil {
            if(event?.isFavorite == true){
                event?.isFavorite = false
                favoriteButton.tintColor = UIColor.white
            } else{
                event?.isFavorite = true
                favoriteButton.tintColor = UIColor.magenta
            }
            EventController.shared.didUpdateEvents(sender: nil)
        }

    }
    
    
    @IBAction func goBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventImage.image = event?.image
        eventName.text = event?.name
        eventAddress.text = event?.address
        eventDate.text = event?.date
        eventDescription.text = event?.description
        
        
        if event?.isFavorite == true{
            favoriteButton.image = UIImage(named: "favoriteIcon")?.withRenderingMode(.alwaysTemplate)
            favoriteButton.tintColor = UIColor.magenta
        } else{
            favoriteButton.image = UIImage(named: "favoriteIcon")?.withRenderingMode(.alwaysTemplate)
            favoriteButton.tintColor = UIColor.white
        }
        
        if event?.isConfirmed == true{
            confirmButton.image = UIImage(named: "doneIcon")?.withRenderingMode(.alwaysTemplate)
            confirmButton.tintColor = UIColor.magenta
        } else{
            confirmButton.image = UIImage(named: "doneIcon")?.withRenderingMode(.alwaysTemplate)
            confirmButton.tintColor = UIColor.white
        }
        
        dateIcon.image = UIImage(named: "dateIcon")?.withRenderingMode(.alwaysTemplate)
        dateIcon.tintColor = UIColor.white
        
        addressIcon.image = UIImage(named: "mapIcon")?.withRenderingMode(.alwaysTemplate)
        addressIcon.tintColor = UIColor.white
        
        menIcon.image = UIImage(named: "menIcon")?.withRenderingMode(.alwaysTemplate)
        menIcon.tintColor = UIColor.white
        
        womanIcon.image = UIImage(named: "womanIcon")?.withRenderingMode(.alwaysTemplate)
        womanIcon.tintColor = UIColor.white
        
        //self.tabBarController?.navigationItem.rightBarButtonItem =
        //self.tabBarController?.navigationItem.leftBarButtonItem = nil

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
