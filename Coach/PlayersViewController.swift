//
//  SecondViewController.swift
//  Coach
//
//  Created by Retina on 29/12/2016.
//  Copyright © 2016 GrinchYourself. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Instantiate the separate storyboard for Players section and load it
        let storyboard = UIStoryboard(name: "Players", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as UIViewController
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

