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

class PhysicsViewController: UIViewController, RecordButtonDelegate {
    
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var freezeButton: UIButton!
    
    // Keep a reference to the scene being presented
    var scene: PhysicsScene!
    
    var freezeView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        scene = PhysicsScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        scene.viewController = self
        skView.presentScene(scene)
        
        // Set up record button to delegate responsibilities to this view controller
        recordButton.delegate = self
        
        // Be notified when app colour scheme changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: AppColourScheme.changed, object: nil)
        
        freezeView.frame = view.frame
        freezeView.backgroundColor = UIColor.cyan
        freezeView.alpha = 0
        freezeView.isUserInteractionEnabled = false
        view.addSubview(freezeView)
        
        updateColours()
    }
    
    func updateColours() {
        view.backgroundColor = AppColourScheme.shared.colourForSimulationBackground()
        helpButton.tintColor = AppColourScheme.shared.colourForHelpButton()
        
        // Update scene's colours
        scene.updateColours()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scene.isPaused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scene.isPaused = true
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
    
    func recordButtonTapped() {
        let skView = view as! SKView
        let physicsScene = skView.scene as! PhysicsScene
        
        physicsScene.initiateRecording()
    }
    
    func stopButtonTapped(sender: RecordButton) {
        let skView = view as! SKView
        let physicsScene = skView.scene as! PhysicsScene
        
        physicsScene.finishRecording(sender: sender)
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
    @IBAction func freezeButtonTapped(_ sender: Any) {
        // Toggle physics frozen/not frozen
        if scene.physicsIsFrozen {
            freezeView.alpha = 0
            
            freezeButton.setTitle("Freeze", for: .normal)
            scene.physicsIsFrozen = false
        } else {
            freezeView.alpha = 0.1
            
            freezeButton.setTitle("Unfreeze", for: .normal)
            scene.physicsIsFrozen = true
        }
    }
    
    @IBAction func unwindFromHelp(segue: UIStoryboardSegue) {
        // don't need to do anything
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Refresh spring lengths when device rotates
        scene?.refreshTripletPositions(toFit: size)
        
        // Make sure any background labels stays in centre
        scene?.refreshLabelPositions(toFit: size)
        
        // Make sure trails react sensibly
        scene?.refreshTrailPositions(toFit: size)
    }
}
