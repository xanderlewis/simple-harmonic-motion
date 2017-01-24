//
//  RecordButton.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 24/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

enum RecordButtonRecordingState {
    case recording
    case stopped
}

enum SpinDirection {
    case left
    case right
}

protocol RecordButtonDelegate {
    func recordButtonTapped()
    func stopButtonTapped()
}

// TODO: Clean up this whole class, separate into functions etc...

//@IBDesignable
class RecordButton: UIButton {
    var recordingState: RecordButtonRecordingState = .stopped
    @IBInspectable var recordingColour = UIColor(red:0.97, green:0.09, blue:0.21, alpha:1.0)
    @IBInspectable var stopColour = UIColor.darkGray
    
    @IBInspectable var recordText = "REC"
    @IBInspectable var stopText = "STOP"
    
    var delegate: RecordButtonDelegate!
    
    override init(frame aFrame: CGRect) {
        super.init(frame: aFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        // Initalise button as record button
        layer.cornerRadius = frame.width / 2
        backgroundColor = recordingColour
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
        layer.borderColor = recordingColour.darker()?.cgColor
        layer.borderWidth = 1
        
        setTitle(recordText, for: .normal)
        setTitleColor(recordingColour.darker(50), for: .normal)
    }
    
    private func becomeRecordButton() {
        recordingState = .stopped
        
        let shapeAnim = CABasicAnimation(keyPath: "cornerRadius")
        shapeAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeAnim.fromValue = 0
        shapeAnim.toValue = frame.width / 2
        shapeAnim.duration = 0.3
        shapeAnim.fillMode = kCAFillModeForwards
        shapeAnim.isRemovedOnCompletion = false
        layer.add(shapeAnim, forKey: "cornerRadius")
        
        let borderAnim = CABasicAnimation(keyPath: "borderColor")
        borderAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        borderAnim.fromValue = layer.borderColor
        borderAnim.toValue = recordingColour.darker(50)?.cgColor
        borderAnim.duration = 0.3
        borderAnim.fillMode = kCAFillModeForwards
        borderAnim.isRemovedOnCompletion = false
        layer.add(borderAnim, forKey: "borderColor")
        
        //spin(.right)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.recordingColour
        }
        
        setTitle(recordText, for: .normal)
        setTitleColor(recordingColour.darker(50), for: .normal)
    }
    
    private func becomeStopButton() {
        recordingState = .recording
        
        let shapeAnim = CABasicAnimation(keyPath: "cornerRadius")
        shapeAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeAnim.fromValue = frame.width / 2
        shapeAnim.toValue = 0
        shapeAnim.duration = 0.3
        shapeAnim.fillMode = kCAFillModeForwards
        shapeAnim.isRemovedOnCompletion = false
        layer.add(shapeAnim, forKey: "cornerRadius")
        
        let borderAnim = CABasicAnimation(keyPath: "borderColor")
        borderAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        borderAnim.fromValue = layer.borderColor
        borderAnim.toValue = UIColor.darkGray.darker()?.cgColor
        borderAnim.duration = 0.3
        borderAnim.fillMode = kCAFillModeForwards
        borderAnim.isRemovedOnCompletion = false
        layer.add(borderAnim, forKey: "borderColor")
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.stopColour
        }
        
        //spin(.left)
        
        setTitle(stopText, for: .normal)
        setTitleColor(stopColour.darker(50), for: .normal)
    }
    
    @objc private func tapped() {
        switch recordingState {
        case .stopped:
            // Tapped record
            
            delegate.recordButtonTapped()
            becomeStopButton()
            
            // Pulse effect
            let pulse = Pulse(numberOfPulses: 1, radius: bounds.width * 24, position: CGPoint(x: bounds.midX, y: bounds.midY))
            pulse.backgroundColor = recordingColour.cgColor
            layer.insertSublayer(pulse, below: nil)
            
            // Start recording process
            
        case .recording:
            // Tapped stop
            
            delegate.stopButtonTapped()
            becomeRecordButton()
            
            // Stop recording -> export popover
            
        }
    }
    
    init(frame: CGRect, recordingColour: UIColor = UIColor(red:0.97, green:0.09, blue:0.21, alpha:1.0), stopColour: UIColor = UIColor.darkGray) {
        self.recordingColour = recordingColour
        self.stopColour = stopColour
        
        super.init(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        // Initalise button as record button
        layer.cornerRadius = frame.width / 2
        backgroundColor = recordingColour
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.borderColor = recordingColour.darker(60)?.cgColor
        layer.borderWidth = 1
        setTitleColor(recordingColour.darker(30), for: .normal)
        
        setTitle(recordText, for: .normal)
    }
    
    private func spin(_ direction: SpinDirection) {
        var angle: CGFloat = 0
        if direction == .left {
            angle = CGFloat(M_PI)
        } else if direction == .right {
            angle = CGFloat(-M_PI)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(rotationAngle: angle)
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: nil)
        }
    }
}