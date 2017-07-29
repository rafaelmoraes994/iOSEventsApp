//
//  EventsTableViewCell.swift
//  ProjetoFinal
//
//  Created by Rafael on 4/30/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventAddress: UILabel!
    
    @IBOutlet weak var eventTags: UILabel!
    
    @IBOutlet weak var eventTagContainer: UIView!
    
    @IBOutlet weak var eventFavoriteButton: UIButton!
    
    @IBOutlet weak var eventSuperView: UIView!
    
    var updateBlock: (() -> ())?
    
    var event: Event? {
        didSet{
            eventImage.image = event?.image
            eventName.text = event?.name
            eventAddress.text = event?.address
            eventDate.text = event?.date
            eventTags.text = event?.tags
            updateFavoriteButton()
        }
    }
    
    
    override func awakeFromNib() {
        eventTagContainer.layer.borderColor = UIColor.purple.cgColor
        eventFavoriteButton.layer.borderColor = UIColor.purple.cgColor
        eventFavoriteButton.setImage(UIImage( named: "favoriteIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        eventFavoriteButton.tintColor = UIColor.white
        eventImage.layer.borderWidth = 1
        eventImage.layer.borderColor = UIColor.purple.cgColor
        eventSuperView.layer.shadowOffset = CGSize(width: 1, height: 1)
        eventSuperView.layer.shadowColor = UIColor.purple.cgColor
        eventSuperView.layer.shadowOpacity = 1;

        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    @IBAction func favoriteEvent(_ sender: AnyObject) {
        event?.isFavorite = !(event?.isFavorite ?? false)
        updateFavoriteButton()
        updateBlock?()
    }
    
    func updateFavoriteButton() {
        if(event?.isFavorite == true){
            eventFavoriteButton.tintColor = UIColor.magenta
        } else{
            eventFavoriteButton.tintColor = UIColor.white
        }
    }
    
    
    
}
