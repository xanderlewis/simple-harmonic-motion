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

enum RecordButtonState {
    case recording
    case stopped
}

enum SpinDirection {
    case left
    case right
}

class PhysicsViewController: UIViewController {
    @IBOutlet weak var recButton: UIButton!
    var recButtonState: RecordButtonState = .stopped
    let recButtonColour = UIColor(red:0.97, green:0.09, blue:0.21, alpha:1.0)
    let stopButtonColor = UIColor.darkGray
    
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
        
        // Initialise record button appearance
        recButton.layer.cornerRadius = recButton.frame.width / 2
        recButton.backgroundColor = recButtonColour
        recButton.layer.shadowColor = UIColor.black.cgColor
        recButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        recButton.layer.shadowRadius = 2
        recButton.layer.shadowOpacity = 0.2
        recButton.layer.borderColor = recButtonColour.darker(60)?.cgColor
        recButton.layer.borderWidth = 1
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
    
    private func spinRecButton(_ direction: SpinDirection) {
        var angle: CGFloat = 0
        if direction == .left {
            angle = CGFloat(M_PI)
        } else if direction == .right {
            angle = CGFloat(-M_PI)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.recButton.transform = CGAffineTransform(rotationAngle: angle)
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
                self.recButton.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: nil)
        }
    }
    
    @IBAction func recButtonTapped(_ sender: AnyObject) {
        switch recButtonState {
        case .stopped:
            recButtonState = .recording
            // Tapped record, transform to stop button
            let shapeAnim = CABasicAnimation(keyPath: "cornerRadius")
            shapeAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            shapeAnim.fromValue = recButton.frame.width / 2
            shapeAnim.toValue = 0
            shapeAnim.duration = 0.3
            shapeAnim.fillMode = kCAFillModeForwards
            shapeAnim.isRemovedOnCompletion = false
            recButton.layer.add(shapeAnim, forKey: "cornerRadius")
            
            let borderAnim = CABasicAnimation(keyPath: "borderColor")
            borderAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            borderAnim.fromValue = recButton.layer.borderColor
            borderAnim.toValue = UIColor.darkGray.darker()?.cgColor
            borderAnim.duration = 0.3
            borderAnim.fillMode = kCAFillModeForwards
            borderAnim.isRemovedOnCompletion = false
            recButton.layer.add(borderAnim, forKey: "borderColor")
            
            UIView.animate(withDuration: 0.3) {
                self.recButton.backgroundColor = self.stopButtonColor
            }
            
            //spinRecButton(.left)
            
            recButton.setTitle("STOP", for: .normal)
            
            // Start recording
            
        case .recording:
            recButtonState = .stopped
            // Tapped stop, transform to record button
            let anim = CABasicAnimation(keyPath: "cornerRadius")
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            anim.fromValue = 0
            anim.toValue = recButton.frame.width / 2
            anim.duration = 0.3
            anim.fillMode = kCAFillModeForwards
            anim.isRemovedOnCompletion = false
            recButton.layer.add(anim, forKey: "cornerRadius")
            
            let borderAnim = CABasicAnimation(keyPath: "borderColor")
            borderAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            borderAnim.fromValue = recButton.layer.borderColor
            borderAnim.toValue = recButtonColour.darker(60)?.cgColor
            borderAnim.duration = 0.3
            borderAnim.fillMode = kCAFillModeForwards
            borderAnim.isRemovedOnCompletion = false
            recButton.layer.add(borderAnim, forKey: "borderColor")
            
            //spinRecButton(.right)

            UIView.animate(withDuration: 0.3) {
                self.recButton.backgroundColor = self.recButtonColour
            }
            
            recButton.setTitle("REC", for: .normal)
            
            // Show export popover
            
        }
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
