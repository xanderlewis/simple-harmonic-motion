//
//  Body.swift
//  SHMPrototype2
//
//  Created by Xander Lewis on 07/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import Foundation
import SpriteKit

class Body: SKShapeNode {
    
    var mass: CGFloat {
        didSet {
            // Change size when mass changes
            path = UIBezierPath(roundedRect: CGRect(x: -mass/2, y: -mass/2, width: mass, height: mass), cornerRadius: 0).cgPath
            
            // Update mass label when mass changes
            massLabel.text = String(describing: mass)
            massLabel.fontSize = mass * massLabelSizeConstant
        }
    }
    let restPosition: CGPoint
    var displacement: CGFloat = 0 {
        didSet {
            // Keep node x position in sync with displacement
            self.position = CGPoint(x: self.restPosition.x + self.displacement , y: self.position.y)
        }
    }
    var velocity: CGFloat = 0
    var acceleration: CGFloat = 0
    
    var damping: CGFloat
    
    var linkedSprings: [Spring] = []
    
    var isFrozen = false
    
    var trail: Trail?
    
    override var fillColor: UIColor {
        didSet {
            // Change trail colour when fill colour changes
            trail?.strokeColor = fillColor
            
            // If new colour dark, change label colour to white
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            fillColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            if r < 0.3 && g < 0.3 && b < 0.3 {
                // White
                massLabel.fontColor = UIColor.white
            } else if r > 0.8 && g > 0.8 && b > 0.8 {
                // Black
                massLabel.fontColor = UIColor.black
            } else {
                // Change mass label colour to slightly darker
                massLabel.fontColor = fillColor.darker(40)!
            }
        }
    }
    
    var massLabel: SKLabelNode!
    let massLabelSizeConstant: CGFloat = 0.3
    
    /**
     Creates a body.
     
     - parameter position: The position of the body in the coordinates of the parent node.
     - parameter colour: The colour of the body.
     - parameter mass: The mass of the body.
     - parameter damping: The damping coefficient to be used to simulate friction acting against the body.
     */
    init(position p: CGPoint, colour c: SKColor, mass m: CGFloat, damping d: CGFloat) {
        
        // Initialise model properties
        self.mass = m
        self.restPosition = p
        self.damping = d
        
        massLabel = SKLabelNode(text: String(describing: m))
        massLabel.fontName = "Damascus Light"
        massLabel.fontSize = m * massLabelSizeConstant
        massLabel.fontColor = c.darker(40)!
        massLabel.horizontalAlignmentMode = .center
        massLabel.verticalAlignmentMode = .center
        massLabel.position = CGPoint.zero
        
        // Initialise node properties
        super.init()
        path = UIBezierPath(roundedRect: CGRect(x: -m/2, y: -m/2, width: m, height: m), cornerRadius: 0).cgPath
        
        addChild(massLabel)
        
        lineWidth = 0
        strokeColor = c.darker(70.0)!
        fillColor = c
        position = p
        zPosition = 100
        name = "body"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Links a spring to the body.
     
     - parameter spring: The spring to be linked to the body.
     */
    func link(spring: Spring) {
        linkedSprings.append(spring)
    }
    
    func unlinkSprings() {
        linkedSprings = []
    }
    
    /**
     Applies a force to the body.
     
    - parameter force: The force to be applied to the body.
    */
    func applyForce(force: CGFloat) {
        self.acceleration = (force / self.mass) - (self.damping * self.velocity)
    }
    
    /**
     Advances the body's position by one 'tick'.
     */
    func updatePosition() {
        self.velocity += self.acceleration
        self.displacement += self.velocity
    }
    
    func updateTrail() {
        if trail != nil {
            trail!.update(sender: self)
        }
    }
}
