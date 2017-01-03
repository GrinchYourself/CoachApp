//
//  PlayerViewController.swift
//  Coach
//
//  Created by Retina on 03/01/2017.
//  Copyright © 2017 GrinchYourself. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    // MARK: - UI's variables
    @IBOutlet weak var ui_playerName: UILabel!
    @IBOutlet weak var ui_playerPhoneNumber: UILabel!
    
    // MARK: - VC's variables
    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }

    func updateUI() {
        title = player.name
        ui_playerName.text = player.name
        ui_playerPhoneNumber.text = player.phoneNumber
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
