//
//  Evento.swift
//  ProjetoFinal
//
//  Created by Rafael on 7/4/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import Foundation
import UIKit


class Event {
    
    var image: UIImage
    var name: String
    var address: String
    var date: String
    var isFavorite: Bool
    var tags: String
    var isConfirmed: Bool
    var description: String
    
    
    init(eventImage: UIImage, eventName: String, eventAddress: String, eventDate: String, isFavorite:Bool, eventTags:String, eventDescription: String, isConfirmed: Bool) {
        self.image = eventImage
        self.name = eventName
        self.address = eventAddress
        self.date = eventDate
        self.isFavorite = isFavorite
        self.tags = eventTags
        self.isConfirmed = isConfirmed
        self.description = eventDescription
    }
    
}
