//
//  SpringShadow.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 20/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit

class SpringShadow: SKShapeNode {
    var currentLength: CGFloat
    
    var width: CGFloat
    var sections: Int
    
    var orientation: SpringOrientation
    
    /**
     Creates a spring.
     
     - parameter width: The width of the spring.
     - parameter sections: The number of 'sections' (V-shapes) the spring has.
     */
    init(position p: CGPoint, orientation o: SpringOrientation, length l: CGFloat, width w: CGFloat, sections sec: Int) {
        
        // Initialise model
        currentLength = l
        width = w
        sections = sec
        orientation = o
        
        super.init()
        
        // Initialise associated node
        position = p
        zPosition = 0
        name = "spring"
        strokeColor = AppColourSchemeDelegate.shared.colourForSpringShadow()
        lineWidth = 2
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
}

