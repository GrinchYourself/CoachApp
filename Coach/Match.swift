//
//  Match.swift
//  Coach
//
//  Created by Retina on 29/12/2016.
//  Copyright © 2016 GrinchYourself. All rights reserved.
//

import Foundation
import RealmSwift

class Match: Object {
    
    dynamic var date: NSDate = NSDate()
    dynamic var time: String = ""
    dynamic var place: String = ""
    dynamic var comment: String? = nil  //Deal for optional properties with String, NSDate et NSData
    let askedPlayers = List<Player>()
    
    //Team1
    dynamic var nameTeam1: String = "Home Team"
    let score1 = RealmOptional<Int>()
    let players1 = List<Player>()
    
    //Team2
    dynamic var nameTeam2: String = "Away Team"
    let score2 = RealmOptional<Int>()
    let players2 = List<Player>()
    
    
}
