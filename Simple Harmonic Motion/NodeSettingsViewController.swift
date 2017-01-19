//
//  NodeSettingsViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 18/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit

class NodeSettingsViewController: UIViewController {
    @IBOutlet var tapRecogniser: UITapGestureRecognizer!
    
    let settingsViewHeight: CGFloat = 180
    let settingsViewWidth: CGFloat = 240
    let settingsViewSpacer: CGFloat = 10
    
    var settingsView: UIView!
    
    var sourceNode: SKNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        tapRecogniser.cancelsTouchesInView = true
        
    }
    
    func showSettings(forObject node: SKNode) {
        
        // Store node as property
        sourceNode = node
        
        // Get node position for easy use
        let nodePosition = node.position.toView(withHeight: view.frame.height)
        
        // Prepare settings view (load from xib file)
        if node is Body {
            settingsView = Bundle.main.loadNibNamed("ObjectSettings", owner: self, options: nil)?[0] as? UIView
        } else if node is Spring {
            settingsView = Bundle.main.loadNibNamed("ObjectSettings", owner: self, options: nil)?[1] as? UIView
        }
        
        view.addSubview(settingsView)
        
        
        // Add layout constraints to settings view
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: settingsView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: settingsViewWidth)
        let heightConstraint = NSLayoutConstraint(item: settingsView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: settingsViewHeight)
        let xConstraint = NSLayoutConstraint(item: settingsView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)

        var yConstraintConstant = nodePosition.y
        
        // If bottom of settings view intersects with bottom of root view
        if yConstraintConstant + settingsViewHeight/2 + settingsViewSpacer > view.frame.height {
            // Shift negative (up)
            yConstraintConstant -= (nodePosition.y + settingsViewHeight/2) - view.frame.height + settingsViewSpacer
            
        // If top of settings view intersects with top of root view
        } else if yConstraintConstant - settingsViewHeight/2 - settingsViewSpacer < 0 {
            // Shift positive (down)
            yConstraintConstant -= (nodePosition.y - settingsViewHeight/2) - settingsViewSpacer
        }
        
        let yConstraint = NSLayoutConstraint(item: settingsView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: yConstraintConstant)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
        
        // Animate the view to appear
        animateAppear(from: sourceNode.position.toView(withHeight: view.frame.height))
    }
    
    // MARK: - Animations
    
    func animateAppear(from originPosition: CGPoint) {
        settingsView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).concatenating(CGAffineTransform(translationX: originPosition.x - view.frame.width/2, y: 0))
        settingsView.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.settingsView.alpha = 1
            self.settingsView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func animateDisappear(to finalPosition: CGPoint) {
        UIView.animate(withDuration: 0.08, animations: {
            self.settingsView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            UIView.animate(withDuration: 0.18, animations: {
                self.settingsView.alpha = 0
                self.settingsView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).concatenating(CGAffineTransform(translationX: finalPosition.x - self.view.frame.width/2, y: 0))
                self.view.backgroundColor = UIColor(white: 0, alpha: 0.0)
            }, completion: { (finished) in
                if finished {
                    self.view.removeFromSuperview()
                }
            })
            
        }
    }
    
    // MARK: Exit From Settings

    @IBAction func tappedView(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let touchPoint = sender.location(ofTouch: 0, in: view)
            
            // If user touched outside of settings view, remove the root view (close node settings)
            if !settingsView.frame.contains(touchPoint) {
                animateDisappear(to: sourceNode.position.toView(withHeight: view.frame.height))
            }
        }
    }
}
