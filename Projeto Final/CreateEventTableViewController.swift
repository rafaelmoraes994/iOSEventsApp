//
//  CreateEventTableViewController.swift
//  ProjetoFinal
//
//  Created by Rafael on 5/24/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit
import Alamofire

class CreateEventTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var commitButton: UIBarButtonItem!
    
    @IBOutlet weak var privacySwitch: UISwitch!

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var beginTime: UITextField!
    
    @IBOutlet weak var endTime: UITextField!
    
    @IBOutlet weak var menPrice: UITextField!
    
    @IBOutlet weak var womanPrice: UITextField!
    
    @IBOutlet weak var localization: UITextField!
    
    @IBOutlet weak var tags: UITextField!
    
    @IBOutlet weak var descriptionTF: UITextField!
    
    
    let picker = UIImagePickerController()
    
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func createEvent(_ sender: AnyObject) {
        let event = Event(eventImage: imageView.image!, eventName: name.text!, eventAddress: localization.text!, eventDate: date.text!, isFavorite: false, eventTags: tags.text!, eventDescription: descriptionTF.text! ,isConfirmed: false)
        EventController.shared.eventsArray.append(event)
        EventController.shared.didUpdateEvents(sender: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "photoIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        
        self.picker.delegate = self
        self.name.delegate = self
        self.date.delegate = self
        self.beginTime.delegate = self
        self.endTime.delegate = self
        self.menPrice.delegate = self
        self.womanPrice.delegate = self
        self.localization.delegate = self
        self.tags.delegate = self
        self.descriptionTF.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
                let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
                imageView.contentMode = .scaleAspectFit //3
                imageView.image = chosenImage
                //imageButton.setImage(chosenImage, for: .normal) //4
                dismiss(animated:true, completion: nil) //5

    }
    
    func storeEventInDataBase(event: Event) {
        
        let parameters: Parameters = [
            "nome": event.name,
            "descricao": event.description,
            "fotoCapa": "",
            "latitude": 37.31,
            "longitude": -122.01,
            "inicio": event.date + " 19:00",
            "fim": event.date + "24:00",
            "tipoEvento": 1
        ]
        
        Alamofire.request("http://localhost:8080/EventosPersonalizadosWebService/EventoOriginal", method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }

}
