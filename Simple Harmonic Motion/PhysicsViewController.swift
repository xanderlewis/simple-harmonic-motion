//
//  PhysicsViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 16/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PhysicsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        let scene = PhysicsScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        scene.viewController = self
        skView.presentScene(scene)
        
        // Set up record button
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func showSettings(forObject node: SKNode) {
        
        // Instantiate node settings view controller and configure it
        let popupVC = storyboard?.instantiateViewController(withIdentifier: "nodesettings") as! NodeSettingsViewController
        addChildViewController(popupVC)
        popupVC.didMove(toParentViewController: self)
        popupVC.showSettings(forObject: node)
        
        // Show node settings
        popupVC.view.frame = view.frame
        view.addSubview(popupVC.view!)
    }
}
