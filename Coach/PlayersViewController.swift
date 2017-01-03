//
//  SecondViewController.swift
//  Coach
//
//  Created by Retina on 29/12/2016.
//  Copyright © 2016 GrinchYourself. All rights reserved.
//

import UIKit
import RealmSwift

class PlayersViewController: UITableViewController {
    
    //MARK: - VC's Variables
    let realm = try! Realm()
    var token: NotificationToken?
    var players : Results<Player>{
        get {
            return realm.objects(Player.self).sorted(byProperty: "name")
        }
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Players")
        // Do any additional setup after loading the view, typically from a nib.
        title = "Players"
        
        token = players.addNotificationBlock { (changes:RealmCollectionChange) in
            self.tableView.reloadData()
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
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "Player" {
            
            if let playerVC = segue.destination as? PlayerViewController {
                
                // Create Fetch Request
                let indexPath = tableView.indexPathForSelectedRow!
                let player = players[indexPath.row]
                
                // Pass the variable
                playerVC.player = player
                
            }
//        } else if segue.identifier! == "NewPlayer" {
//            if let destVC = segue.destination as? UINavigationController {
//                let playerEditionVC = destVC.topViewController as! PlayerEditionViewController
//                // Informs PlayerEditionViewController that we create a new Player
//                playerEditionVC.editNotNew = false
//                playerEditionVC.delegate = self
//                player = nil
//            }
//            
//        } else if segue.identifier! == "ShowNewPlayer" {
//            if let playerVC = segue.destination as? PlayerViewController {
//                
//                // Pass the variable
//                playerVC.player = player
//                
//            }
//            
//        }
        }
    }

}

