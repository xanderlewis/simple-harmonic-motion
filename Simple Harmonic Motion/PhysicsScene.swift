//
//  PhysicsScene.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 16/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import SpriteKit
import GameplayKit

// Default physics constants for simulation (used when creating new objects)
struct DefaultConstants {
    static let colour = SKColor.white
    static let mass: CGFloat = 60
    static let damping: CGFloat = 0.1
    static let springWidth: CGFloat = 30
    static let springStiffness: CGFloat = 0.01
    static let springSections: Int = 12
}

class PhysicsScene: SKScene {
    
    // Gesture recognisers
    var tapRec: UITapGestureRecognizer!
    var longPressRec: UILongPressGestureRecognizer!
    
    override func didMove(to view: SKView) {
        // Set up gesture recognisers
        setUpGestureRecognizers()
        
        // Set background colour
        backgroundColor = UIColor(white: 0.6, alpha: 1)
    }
    
    func tickPhysics() {
        // Deform springs based on displacement of linked bodies
        enumerateChildNodes(withName: "spring") { (node, stop) in
            let spring = node as! Spring
            if !spring.linkedBodies.isEmpty {
                for body in spring.linkedBodies {
                    spring.deform(change: body.displacement)
                }
            }
        }
        
        // Apply springs forces to (non-locked) linked bodies and update their positions
        enumerateChildNodes(withName: "body") { (node, stop) in
            let body = node as! Body
            
            if !body.isLocked {
                if !body.linkedSprings.isEmpty {
                    for spring in body.linkedSprings {
                        body.applyForce(force: spring.force)
                    }
                }
                body.updatePosition()
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Move physics forward one 'tick'
        tickPhysics()
    }
    
    func createTriplet(atPosition bodyPosition: CGPoint) {
        // Create a spring-body-spring 'triplet'
        
        let body = Body(position: CGPoint(x: frame.width / 2, y: bodyPosition.y),
                        colour: DefaultConstants.colour,
                        mass: DefaultConstants.mass,
                        damping: DefaultConstants.damping)
        
        let leftSpring = Spring(position: CGPoint(x: 0,
                                                  y: body.position.y - DefaultConstants.springWidth / 2),
                                colour: DefaultConstants.colour,
                                length: body.position.x - body.mass / 2,
                                width: DefaultConstants.springWidth,
                                stiffness: DefaultConstants.springStiffness,
                                sections: DefaultConstants.springSections)
        
        let rightSpring = Spring(position: CGPoint(x: body.position.x + body.mass / 2,
                                                   y: body.position.y - DefaultConstants.springWidth / 2),
                                 colour: DefaultConstants.colour,
                                 length: frame.width - (body.position.x + body.mass / 2),
                                 width: DefaultConstants.springWidth,
                                 stiffness: DefaultConstants.springStiffness,
                                 sections: DefaultConstants.springSections)
        
        // Link bodies and springs
        body.link(spring: leftSpring)
        leftSpring.link(body: body)
        body.link(spring: rightSpring)
        rightSpring.link(body: body)
        
        // Add as children to scene (root node)
        self.addChild(body)
        self.addChild(leftSpring)
        self.addChild(rightSpring)
        
    }
    
    // MARK: - Gesture Responses
    
    func tappedScene(sender: UITapGestureRecognizer) {
        // Called when user taps on scene
        
        if sender.state == .ended {
            print("Tapped physics scene!")
            
            // Get location of tap
            let tapLocation = sender.location(in: view)
            
            // Create 'triplet'
            createTriplet(atPosition: convertPoint(fromView: tapLocation))
        }
        
    }
    
    func longPressedScene() {
        // Called when user taps and holds on scene for a while
        
        print("Long pressed physics scene!")
    }
    
    func setUpGestureRecognizers() {
        tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedScene))
        longPressRec = UILongPressGestureRecognizer(target: self, action: #selector(longPressedScene))
        
        longPressRec.minimumPressDuration = 0.8
        
        view?.addGestureRecognizer(tapRec)
        view?.addGestureRecognizer(longPressRec)
    }
}
