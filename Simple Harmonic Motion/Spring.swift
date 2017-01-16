//
//  Spring.swift
//  SHMPrototype2
//
//  Created by Xander Lewis on 07/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import Foundation
import SpriteKit

class Spring: SKShapeNode {
    
    let initialLength: CGFloat
    var currentLength: CGFloat
    var stiffness: CGFloat
    
    var force: CGFloat {
        get {
            return -stiffness * (currentLength - initialLength) // F = -kx
        }
    }
    
    var linkedBodies: [Body] = []
    
    var width: CGFloat
    var sections: Int
    
    /**
     Creates a spring.
     
     - parameter width: The width of the spring.
     - parameter sections: The number of 'sections' (V-shapes) the spring has.
     */
    init(position p: CGPoint, colour c: SKColor, length l: CGFloat, width w: CGFloat, stiffness st: CGFloat, sections sec: Int) {
        
        // Initialise model
        initialLength = l
        currentLength = l
        stiffness = st
        width = w
        sections = sec
        
        super.init()
        
        // Initialise associated node
        position = p
        zPosition = 0
        name = "spring"
        strokeColor = c
        lineWidth = 1
        lineCap = .round
        
        updateSpringPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Updates the spring's path (shape).
     */
    private func updateSpringPath() {
        // Create new path
        let newPath = CGMutablePath()
        newPath.move(to: CGPoint.zero)
        
        // Calculate path constants
        let sectionLength = currentLength / CGFloat(sections)
        let bottom: CGFloat = 0
        let top = width
        
        print("length" + String(describing: currentLength))
        print("sectionLength" + String(describing: sectionLength))
        print("top" + String(describing: top))
        print("bottom" + String(describing: bottom))
        
        // Generate path
        for i in stride(from: 1, to: sections, by: 2) {
            newPath.addLine(to: CGPoint(x: sectionLength * CGFloat(i), y: top))
            newPath.addLine(to: CGPoint(x: sectionLength * CGFloat(i+1), y: bottom))
        }
        
        // Set new path
        path = newPath
    }
    
    /**
     Changes the length of the spring.
     
     - parameter change: The amount by which to modify the length. (can be positive or negative)
     */
    func deform(change: CGFloat) {
        currentLength = initialLength + change
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
