//
//  SecondViewController.swift
//  Coach
//
//  Created by Retina on 29/12/2016.
//  Copyright © 2016 GrinchYourself. All rights reserved.
//

import UIKit
import RealmSwift

class PlayersViewController: UITableViewController, EditionDelegate {
    
    //MARK: - VC's Variables
    let realm = try! Realm()
    var token: NotificationToken?
    var players : Results<Player>{
        get {
            return realm.objects(Player.self).sorted(byProperty: "name")
        }
    }
    var player:Player = Player()

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
                playerEditionVC.editNotNew = false
                playerEditionVC.delegate = self
                playerEditionVC.player = nil
            }
            
        } else if segue.identifier! == "ShowNewPlayer" {
            if let playerVC = segue.destination as? PlayerViewController {
                // Pass the variable
                playerVC.player = player
            }
            
        }
    }

    func dismissEditionViewController(controller: UIViewController, player: Player?) {
        //This function allows to pass player variable and launch PlayerViewController before dismissing EditionViewController
        if player != nil{
            self.player = player!
            self.performSegue(withIdentifier: "ShowNewPlayer", sender: nil)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

