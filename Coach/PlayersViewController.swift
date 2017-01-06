//
//  SecondViewController.swift
//  Coach
//
//  Created by Retina on 29/12/2016.
//  Copyright © 2016 GrinchYourself. All rights reserved.
//

import UIKit
import RealmSwift
import ContactsUI

enum playerStatus {
    case none
    case newManually
    case newFromContacts
    case edit
}

class PlayersViewController: UITableViewController, CNContactPickerDelegate, EditionDelegate {
    
    //MARK: - VC's Variables
    let realm = try! Realm()
    var token: NotificationToken?
    var players : Results<Player>{
        get {
            return realm.objects(Player.self).sorted(byProperty: "name")
        }
    }
    var player:Player?
    let contactPicker = CNContactPickerViewController()
    var playerStatus:playerStatus?

    //MARK: - Actions
    @IBAction func addNewPlayer(_ sender: UIBarButtonItem) {
        //init player variable
        player = nil
        // Create and initialize an UIAlertController instance.
        let alertController = UIAlertController(title: "Add New Player", message: nil, preferredStyle: .actionSheet)
        // Initialize the actions to show along with the alert.
        let manualAction = UIAlertAction(title:"Manually", style: .default) { (action) -> Void in
            print("You selected the manual action")
            self.playerStatus = .newManually
            self.performSegue(withIdentifier: "NewPlayer", sender: nil)
        }
        
        let contactAction = UIAlertAction(title:"From your Contacts", style: .default) { (action) -> Void in
            print("You selected the contact action")
            self.contactPicker.delegate = self
            self.contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
            self.present(self.contactPicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) { (action) -> Void in
            print("You selected the Cancel action")
        }
        
        // Tell the alertController about the actions we want it to present.
        alertController.addAction(manualAction)
        alertController.addAction(contactAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller and associated actions.
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Players")
        // Do any additional setup after loading the view, typically from a nib.
        title = "Players"
        
        token = players.addNotificationBlock { (changes:RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //When the contactPicker will disappear, it's time to present the editionPlayerViewController
        if let pl = playerStatus {
            if pl == .newFromContacts {
                self.performSegue(withIdentifier: "NewPlayer", sender: nil)
                //initialisation of the players's status to avoid the launch of the editionPlayerVC when PlayerVC->PlayersVC
                playerStatus = .none
            }
        }
    }
    
    //MARK: - TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "Toto", for: indexPath)

        cell.textLabel?.text = players[indexPath.row].name
        cell.detailTextLabel?.text = players[indexPath.row].phoneNumber
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pl = players[indexPath.row]
            try! self.realm.write {
                self.realm.delete(pl)
            }
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "Player" {
            
            if let playerVC = segue.destination as? PlayerViewController {
                
                // Get selected player
                let indexPath = tableView.indexPathForSelectedRow!
                let player = players[indexPath.row]
                
                // Pass the variable
                playerVC.player = player
                
            }
        } else if segue.identifier! == "NewPlayer" {
            if let destVC = segue.destination as? UINavigationController {
                let playerEditionVC = destVC.topViewController as! PlayerEditionViewController
                // Informs PlayerEditionViewController that we create a new Player
                playerEditionVC.status = playerStatus!
                playerEditionVC.delegate = self
                playerEditionVC.player = player
            }
            
        } else if segue.identifier! == "ShowNewPlayer" {
            if let playerVC = segue.destination as? PlayerViewController {
                // Pass the variable
                playerVC.player = player!
            }
            
        }
    }

    //MARK: - EditionDelegate Method
    func dismissEditionViewController(controller: UIViewController, player: Player?) {
        //This function allows to pass player variable and launch PlayerViewController before dismissing EditionViewController
        if player != nil{
            self.player = player!
            self.performSegue(withIdentifier: "ShowNewPlayer", sender: nil)
        }
        controller.dismiss(animated: true, completion: nil)
    }

    
    //MARK: - ContactsUI Methods
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as! CNPhoneNumber
        print(getContactName(contact: contact))
        print(phoneNumber.stringValue)
        //Prepare the navigation
        self.playerStatus = .newFromContacts
        player = Player()
        player!.name = getContactName(contact: contact)
        player!.phoneNumber = phoneNumber.stringValue
    }
    
    func getContactName(contact:CNContact) -> String {
        var contactName: String = ""
        if contact.namePrefix != "" { contactName = contactName + contact.namePrefix + " " }
        if contact.givenName != "" { contactName = contactName + contact.givenName + " " }
        if contact.middleName != "" { contactName = contactName + contact.middleName + " " }
        if contact.familyName != "" { contactName = contactName + contact.familyName + " " }
        if contact.nameSuffix != "" { contactName = contactName + contact.nameSuffix + " " }
        return contactName.trimmingCharacters(in: .whitespaces)
    }
}

