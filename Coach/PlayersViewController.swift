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
    var players : Results<Player>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Players")
        players = realm.objects(Player.self).sorted(byProperty: "name")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players!.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            //iToPlay += 1
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Toto", for: indexPath)
//            // Configure the cell...
//        //let task = tasks![1]
//        let index = Int(indexPath)
//        let player = players![index]
//        //cell.textLabel = player.
//            return cell
//        
//    }
}

