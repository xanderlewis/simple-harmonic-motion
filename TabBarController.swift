//
//  TabBarController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 01/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get reference to all views in tab bar (helps with performance)
        for viewController in viewControllers! {
            let _ = viewController.view!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
