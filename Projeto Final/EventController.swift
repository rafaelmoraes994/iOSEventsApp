//
//  File.swift
//  ProjetoFinal
//
//  Created by Rafael on 7/4/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import Foundation
import UIKit

protocol EventObserver: class {
    func didUpdateEvents(sender: EventObserver?)
}

class EventController {
    
    //Singleton
    fileprivate init() {}
    static let shared: EventController = EventController()
    
    //Test Events
    var eventsArray: [Event] = [Event(eventImage: #imageLiteral(resourceName: "eventImage1"), eventName: "Unity Club - Hillel Mathews", eventAddress: "Rua Inventada 731 - Barra da Tijuca", eventDate: "Sex, 5 Maio - 10:30 PM", isFavorite: true, eventTags: "Tag: Festa  Tag: DJ", eventDescription: "Festa mais esperada do Ano!\n\n▸ Masculino: R$ 40,00\n▸ Feminino: R$ 20,00", isConfirmed: true), Event(eventImage: #imageLiteral(resourceName: "eventImage2"), eventName: "Unity Club - Les Feux D'Artifices Au Unity", eventAddress: "Rua XPTO 919 - Botafogo", eventDate: "Sat, 17 Maio - 9:00 PM", isFavorite: false, eventTags: "Tag: Universitario", eventDescription: "Festa mais esperada do Ano!\n\n▸ Masculino: R$ 40,00\n▸ Feminino: R$ 20,00", isConfirmed: false), Event(eventImage: #imageLiteral(resourceName: "eventImage3"), eventName: "Unity Club - Hillel", eventAddress: "Rua Inventada 665 - Copacabana", eventDate: "Sex, 29 Abril - 10:00 PM" , isFavorite: true, eventTags: "Tag: Boate  Tag: Musica ao Vivo ", eventDescription: "Festa mais esperada do Ano!\n\n▸ Masculino: R$ 40,00\n▸ Feminino: R$ 20,00", isConfirmed: false)]
    
    var observerArray: [EventObserver] = []
    
    fileprivate var localFilteredArray : [Event]?
    var filteredArray: [Event] {
        get {
            return localFilteredArray ?? eventsArray
        }
        set {
            localFilteredArray = newValue
        }
    }
    
    func findFavoriteEvents() -> [Event] {
        var favoriteEventsArray: [Event] = []
        
        for event in eventsArray {
            if event.isFavorite{
                favoriteEventsArray.append(event)
            }
        }
        return favoriteEventsArray
    }
    
    func findConfirmedEvents() -> [Event] {
        var confirmedEventsArray: [Event] = []
        
        for event in eventsArray {
            if event.isConfirmed{
                confirmedEventsArray.append(event)
            }
        }
        return confirmedEventsArray
    }

    
    func didUpdateEvents(sender: EventObserver?){
        for observer in observerArray{
            observer.didUpdateEvents(sender: sender)
        }
    }
    
}
