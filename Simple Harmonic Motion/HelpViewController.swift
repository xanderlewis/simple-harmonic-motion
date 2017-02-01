//
//  HelpViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 01/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("tap!!")
        performSegue(withIdentifier: "UnwindHelp", sender: self)
    }

}
