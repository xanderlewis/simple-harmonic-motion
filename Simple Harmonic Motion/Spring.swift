//
//  Spring.swift
//  SHMPrototype2
//
//  Created by Xander Lewis on 07/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import Foundation
import SpriteKit

enum SpringOrientation {
    case facingLeft
    case facingRight
}

class Spring: SKShapeNode {
    
    let initialLength: CGFloat
    var currentLength: CGFloat
    var stiffness: CGFloat
    
    var force: CGFloat {
        get {
            if orientation == .facingRight {
                return -stiffness * (currentLength - initialLength) // F = -kx
            } else {
                return stiffness * (currentLength - initialLength) // F = -kx
            }
        }
    }
    
    var linkedBodies: [Body] = []
    
    var width: CGFloat
    var sections: Int
    
    var orientation: SpringOrientation
    
    /**
     Creates a spring.
     
     - parameter width: The width of the spring.
     - parameter sections: The number of 'sections' (V-shapes) the spring has.
     */
    init(position p: CGPoint, colour c: SKColor, orientation o: SpringOrientation, length l: CGFloat, width w: CGFloat, stiffness st: CGFloat, sections sec: Int) {
        
        // Initialise model
        initialLength = l
        currentLength = l
        stiffness = st
        width = w
        sections = sec
        orientation = o
        
        super.init()
        
        // Initialise associated node
        position = p
        zPosition = 20
        name = "spring"
        strokeColor = c
        lineWidth = 1
        lineCap = .round
        
        updatePath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Updates the spring's path (shape).
     */
    func updatePath() {
        // Create new path
        let newPath = CGMutablePath()
        
        // Calculate path constants
        var sectionLength = currentLength / CGFloat(sections)
        if orientation == .facingLeft {
            sectionLength = -currentLength / CGFloat(sections)
        }
        
        let bottom: CGFloat = 0
        let top = width
        
        // Generate path
        
        if orientation == .facingRight {
            newPath.move(to: CGPoint.zero)
            // Populate path
            for i in stride(from: 1, to: sections, by: 2) {
                newPath.addLine(to: CGPoint(x: sectionLength * CGFloat(i), y: top))
                newPath.addLine(to: CGPoint(x: sectionLength * CGFloat(i+1), y: bottom))
            }
        } else {
            //newPath.move(to: CGPoint(x: sectionLength * CGFloat(sections), y: 0))
            newPath.move(to: CGPoint.zero)
            // Populate path
            for i in stride(from: 1, to: sections, by: 2) {
                newPath.addLine(to: CGPoint(x: sectionLength * CGFloat(i), y: top))
                newPath.addLine(to: CGPoint(x: sectionLength * CGFloat(i+1), y: bottom))
            }
        }
        
        
        
        // Set new path
        path = newPath
    }
    
    /**
     Changes the length of the spring.
     
     - parameter change: The amount by which to modify the length. (can be positive or negative)
     */
    func deform(change: CGFloat) {
        if orientation == .facingRight {
            currentLength = initialLength + change
        } else {
            currentLength = initialLength - change
        }
        
    }
    
    /**
     Links a body to the spring.
     
     - parameter body: The body to be linked to the spring.
     */
    func link(body: Body) {
        linkedBodies.append(body)
    }
    
    func unlink(body: Body) {
        linkedBodies = []
    }
}
