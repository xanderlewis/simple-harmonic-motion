//
//  NodeSettingsViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 18/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit

public struct BodyColourPalette {
    static let colour1 = UIColor(red:0.00, green:0.09, blue:0.15, alpha:1.0)
    static let colour2 = UIColor(red:0.97, green:0.09, blue:0.21, alpha:1.0)
    static let colour3 = UIColor(red:0.25, green:0.92, blue:0.83, alpha:1.0)
    static let colour4 = UIColor(red:0.99, green:1.00, blue:0.99, alpha:1.0)
    static let colour5 = UIColor(red:1.00, green:0.62, blue:0.11, alpha:1.0)
    static let colour6 = UIColor(red:0.80, green:0.55, blue:0.53, alpha:1.0)
}

class NodeSettingsViewController: UIViewController {
    @IBOutlet var tapRecogniser: UITapGestureRecognizer!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    let settingsViewSpacer: CGFloat = 4
    var settingsView: UIView!
    var sourceNode: SKNode!
    
    // MARK: - Body settings outlets
    @IBOutlet weak var massSlider: UISlider!
    @IBOutlet weak var dampingSlider: UISlider!
    @IBOutlet weak var bodySettingsView: UIView!
    @IBOutlet weak var colour1Button: UIButton!
    @IBOutlet weak var colour2Button: UIButton!
    @IBOutlet weak var colour3Button: UIButton!
    @IBOutlet weak var colour4Button: UIButton!
    @IBOutlet weak var colour5Button: UIButton!
    @IBOutlet weak var colour6Button: UIButton!
    @IBOutlet weak var bodySettingsLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    
    // MARK: - Spring settings outlets
    @IBOutlet weak var stiffnessSlider: UISlider!
    @IBOutlet weak var springSettingsView: UIView!
    @IBOutlet weak var springSettingsLabel: UILabel!
    @IBOutlet weak var stiffnessLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        tapRecogniser.cancelsTouchesInView = true
        
        // Start with popup views hidden
        bodySettingsView.alpha = 0
        springSettingsView.alpha = 0
        
        // Set up colour buttons
        colour1Button.backgroundColor = BodyColourPalette.colour1
        colour2Button.backgroundColor = BodyColourPalette.colour2
        colour3Button.backgroundColor = BodyColourPalette.colour3
        colour4Button.backgroundColor = BodyColourPalette.colour4
        colour5Button.backgroundColor = BodyColourPalette.colour5
        colour6Button.backgroundColor = BodyColourPalette.colour6
        
        // Hide blur view
        self.visualEffectView.alpha = 0
    }
    
    private func updateUIColors(basedOnBody body: Body) {
        
        let colour = body.fillColor
        
        bodySettingsView.backgroundColor = colour
        
        massSlider.minimumTrackTintColor = colour.darker(50)!
        massSlider.maximumTrackTintColor = colour.darker(50)!
        
        dampingSlider.minimumTrackTintColor = colour.darker(50)!
        dampingSlider.maximumTrackTintColor = colour.darker(50)!
        
        let buttons = [colour1Button, colour2Button, colour3Button, colour4Button, colour5Button, colour6Button]
        
        for button in buttons {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = button?.backgroundColor?.darker(20)!.cgColor
        }
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        // Make colours light if background becomes too dark
        colour.getRed(&r, green: &g, blue: &b, alpha: &a)
        if r < 0.3 && g < 0.3 && b < 0.3 {
            bodySettingsLabel.textColor = UIColor.white
            massLabel.textColor = UIColor.white
            dampingLabel.textColor = UIColor.white
            colourLabel.textColor = UIColor.white
            
            massSlider.minimumTrackTintColor = colour.lighter(70)!
            massSlider.maximumTrackTintColor = colour.lighter(70)!
            dampingSlider.minimumTrackTintColor = colour.lighter(70)!
            dampingSlider.maximumTrackTintColor = colour.lighter(70)!
        } else {
            bodySettingsLabel.textColor = UIColor.black
            massLabel.textColor = UIColor.black
            dampingLabel.textColor = UIColor.black
            colourLabel.textColor = UIColor.black
            
            massSlider.minimumTrackTintColor = colour.darker(70)!
            massSlider.maximumTrackTintColor = colour.darker(70)!
            dampingSlider.minimumTrackTintColor = colour.darker(70)!
            dampingSlider.maximumTrackTintColor = colour.darker(70)!
        }

    }
    
    func showSettings(forObject node: SKNode) {
        
        // Store node as property
        sourceNode = node
        
        // Get node position for easy use
        let nodePosition = node.position.toView(withHeight: view.frame.height)
        
        // Prepare settings view (load from xib file)
        if let body = node as? Body {
            // Show spring settings
            bodySettingsView.alpha = 1
            settingsView = bodySettingsView
            
            // Update UI to current settings
            massSlider.value = Float(body.mass)
            dampingSlider.value = Float(body.damping)
            
            // Update UI colours
            updateUIColors(basedOnBody: body)
            
        } else if let spring = node as? Spring {
            // Show spring settings
            springSettingsView.alpha = 1
            settingsView = springSettingsView
            
            // Update UI to current settings
            stiffnessSlider.value = Float(spring.stiffness)
        }
        
        // Add layout constraints for settings view
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: settingsView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: settingsView.frame.width)
        let heightConstraint = NSLayoutConstraint(item: settingsView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: settingsView.frame.height)
        let xConstraint = NSLayoutConstraint(item: settingsView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)

        var yConstraintConstant = nodePosition.y
        
        // If bottom of settings view intersects with bottom of root view
        if yConstraintConstant + settingsView.frame.height/2 + settingsViewSpacer > view.frame.height {
            // Shift negative (up)
            yConstraintConstant -= (nodePosition.y + settingsView.frame.height/2) - view.frame.height + settingsViewSpacer
            
        // If top of settings view intersects with top of root view
        } else if yConstraintConstant - settingsView.frame.height/2 - settingsViewSpacer < 0 {
            // Shift positive (down)
            yConstraintConstant -= (nodePosition.y - settingsView.frame.height/2) - settingsViewSpacer
        }
        
        let yConstraint = NSLayoutConstraint(item: settingsView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: yConstraintConstant)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
        
        // Animate the view to appear
        animateAppear(from: sourceNode.position.toView(withHeight: view.frame.height))
    }
    
    // MARK: - Object settings actions
    
    @IBAction func massSliderChanged(_ sender: UISlider) {
        if let body = sourceNode as? Body {
            body.mass = CGFloat(sender.value)
        }
    }
    
    @IBAction func dampingSliderChanged(_ sender: UISlider) {
        if let body = sourceNode as? Body {
            body.damping = CGFloat(sender.value)
        }
    }
    
    @IBAction func stiffnessSliderChanged(_ sender: UISlider) {
        if let spring = sourceNode as? Spring {
            spring.stiffness = CGFloat(sender.value)
        }
    }
    
    @IBAction func colourButton1Pressed(_ sender: UIButton) {
        if let body = sourceNode as? Body {
            body.fillColor = sender.backgroundColor!
            updateUIColors(basedOnBody: body)
        }
    }
    
    @IBAction func colourButton2Pressed(_ sender: UIButton) {
        if let body = sourceNode as? Body {
            body.fillColor = sender.backgroundColor!
            updateUIColors(basedOnBody: body)
        }
    }
    
    @IBAction func colourButton3Pressed(_ sender: UIButton) {
        if let body = sourceNode as? Body {
            body.fillColor = sender.backgroundColor!
            updateUIColors(basedOnBody: body)
        }
    }
    
    @IBAction func colourButton4Pressed(_ sender: UIButton) {
        if let body = sourceNode as? Body {
            body.fillColor = sender.backgroundColor!
            updateUIColors(basedOnBody: body)
        }
    }
    
    @IBAction func colourButton5Pressed(_ sender: UIButton) {
        if let body = sourceNode as? Body {
            body.fillColor = sender.backgroundColor!
            updateUIColors(basedOnBody: body)
        }
    }
    
    @IBAction func colourButton6Pressed(_ sender: UIButton) {
        if let body = sourceNode as? Body {
            body.fillColor = sender.backgroundColor!
            updateUIColors(basedOnBody: body)
        }
    }
    
    // MARK: - Animations
    
    func animateAppear(from originPosition: CGPoint) {
        settingsView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).concatenating(CGAffineTransform(translationX: originPosition.x - view.frame.width/2, y: 0))
        settingsView.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
            self.visualEffectView.alpha = 1
            self.settingsView.alpha = 1
            self.settingsView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func animateDisappear(to finalPosition: CGPoint) {
        UIView.animate(withDuration: 0.08, animations: {
            self.settingsView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                self.settingsView.alpha = 0
                self.settingsView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).concatenating(CGAffineTransform(translationX: finalPosition.x - self.view.frame.width/2, y: 0))
                self.view.backgroundColor = UIColor(white: 0, alpha: 0.0)
                self.visualEffectView.alpha = 0
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
