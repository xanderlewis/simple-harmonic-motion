//
//  Extensions.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 18/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

// Defines an extension that allows the creation of lighter or darker colours from a reference colour
extension UIColor {
    func lighter(_ percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust( abs(percentage))
    }
    
    func darker(_ percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust( -1 * abs(percentage))
    }
    
    private func adjust(_ percentage: CGFloat = 30.0) -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0;
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + percentage/100, 1.0), green: min(g + percentage/100, 1.0), blue: min(b + percentage/100, 1.0), alpha: a)
        } else {
            return nil
        }
    }
}

// Convert scene coordinates to view coordinates

extension CGPoint {
    func toView(withHeight height: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: height - self.y)
    }
}
