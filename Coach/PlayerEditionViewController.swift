//
//  PlayerEditionViewController.swift
//  Coach
//
//  Created by Retina on 02/01/2017.
//  Copyright © 2017 GrinchYourself. All rights reserved.
//

import UIKit
import RealmSwift

protocol EditionDelegate {
    func dismissEditionViewController(controller: UIViewController, player: Player?)
}

class PlayerEditionViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - UI's Variables
    @IBOutlet weak var ui_namePlayer: UITextField!
    @IBOutlet weak var ui_phoneNumberPlayer: UITextField!
    @IBOutlet weak var ui_doneEditionPlayerButton: UIBarButtonItem!
    @IBOutlet weak var ui_deletePlayerButton: UIButton!
    
    //MARK: - VC's Variables
    var delegate : EditionDelegate!
    let realm = try! Realm()
    var player : Player?
    var status: playerStatus? //Variable to be defined in the "prepare" function called with the segue
    
    //MARK: - UI Methods
    @IBAction func cancelEditionPlayer(_ sender: UIBarButtonItem) {
        //Hide keyboard if user cancels during edition
        hideKeyboard()
        
        //Back to previous VC
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveEditionPlayer(_ sender: UIBarButtonItem) {
        print("Save Player's edition")
        // This function is available only if the player's name is filled in
        let pl = Player()
        pl.name = ui_namePlayer.text!.trimmingCharacters(in: .whitespaces)
        pl.phoneNumber = ui_phoneNumberPlayer.text!
        try! realm.write {
            realm.add(pl, update:true)
        }
        //Use of delegate to dismiss
        self.delegate!.dismissEditionViewController(controller: self, player: pl)
    }
    @IBAction func deletePlayer() {
        print("Delete Player")
        // Create and initialize a UIAlertController instance.
        let alertController = UIAlertController(title: nil, message: "Do you really want to delete \(player!.name)?", preferredStyle: .actionSheet)
        // Initialize the actions to show along with the alert.
        let deleteAction = UIAlertAction(title:"Delete", style: .destructive) { (action) -> Void in
            print("You selected the delete action")
            try! self.realm.write {
                self.realm.delete(self.player!)
            }
            //Use of delegate to dismiss
            self.delegate!.dismissEditionViewController(controller: self, player: nil)
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) { (action) -> Void in
            print("You selected the Cancel action")
        }
        // Tell the alertController about the actions we want it to present.
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        // Present the alert controller and associated actions.
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //VC's title and player init
        if (status! == .edit) || (status! == .newFromContacts )  {
            title = player!.name
            ui_namePlayer.text = player!.name
            ui_phoneNumberPlayer.text = player!.phoneNumber
        } else {
            title = "New Player"
            player = Player()
        }
        //Done button
        ui_doneEditionPlayerButton.isEnabled = false
        
        //Delegate of UITextField
        ui_namePlayer.delegate = self
        ui_phoneNumberPlayer.delegate = self
        
        //Add Gestures to hide the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PlayerEditionViewController.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        let slideDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(PlayerEditionViewController.hideKeyboard))
        slideDownGesture.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(slideDownGesture)
        
        //Activate or disable nameTextField & delete button
        if status! == .edit {
            ui_namePlayer.isEnabled = false
            ui_deletePlayerButton.isHidden = false
        } else {
            ui_namePlayer.becomeFirstResponder()
            ui_deletePlayerButton.isHidden = true
        }
        //Print realm datafile
        print("Realm File: \(Realm.Configuration.defaultConfiguration.fileURL!)")

    }
    
    // MARK: - UITextField Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Start edition of Player -> Button done not accessible No Save during edition
        ui_doneEditionPlayerButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidPlayerName(textField)
        if textField === ui_namePlayer {
            // Add the title of the view with the player's name
            title = textField.text
        }
    }
    
    func hideKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - VC Methods
    
    func checkValidPlayerName(_ textField: UITextField) {
        // Disable the Save button if the text field is empty.
        let text = ui_namePlayer.text ?? ""
        ui_doneEditionPlayerButton.isEnabled = !text.isEmpty
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
