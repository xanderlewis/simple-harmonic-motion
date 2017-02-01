//
//  OptionsViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 01/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let tableViewController = childViewControllers[0] as? UITableViewController {
            tableViewController.tableView.separatorColor = UIColor.darkGray
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
