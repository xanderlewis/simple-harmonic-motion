//
//  GraphView.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 08/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

struct Grid {
}

class GraphView: UIView {
    var gridLayer: CAShapeLayer!
    var axesLayer: CAShapeLayer!
    var plotLayer: CAShapeLayer!
    
    var axesColour = UIColor(white: 0.25, alpha: 1)
    var gridColour = UIColor(white: 0.12, alpha: 1)
    
    var xColour = AppColourScheme.shared.colourForUIElementTint()
    
    private var xData: [Float]! {
        didSet {
            if yData != nil && xData != nil {
                plotData()
            }
        }
    }
    
    private var yData: [Float]! {
        didSet {
            if xData != nil && yData != nil {
                plotData()
            }
        }
    }
    
    var xAxisMargin: CGFloat = 45
    var yAxisMargin: CGFloat = 45
    
    var origin: CGPoint {
        return CGPoint(x: yAxisMargin, y: xAxisMargin + xLength)
    }
    
    var xPointsShowing: Int {
        if xData != nil {
            return xData.count
        } else {
            return 10
        }
    }
    var yPointsShowing: Int {
        if yData != nil {
            return yData.count
        } else {
            return 10
        }
    }
    
    var xLength: CGFloat {
        return (frame.width - yAxisMargin * 2)
    }
    
    var yLength: CGFloat {
        return (frame.height - xAxisMargin * 2)
    }
    
    var xPointInterval: CGFloat {
        return xLength / CGFloat(xPointsShowing)
    }
    
    var yPointInterval: CGFloat {
        return yLength / CGFloat(yPointsShowing)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        gridLayer = createGridLayer()
        axesLayer = createAxesLayer()
        
        layer.addSublayer(gridLayer)
        layer.insertSublayer(axesLayer, above: gridLayer)
        
        addLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    func add(xData data: [Float]) {
        // Add new data for x axis, replacing old data
        xData = data
    }
    
    func add(yData data: [Float]) {
        // Add new data for y axis, replacing old data
        yData = data
    }
    
    func clear() {
        plotLayer.removeFromSuperlayer()
        plotLayer = nil
        xData = nil
        yData = nil
    }
    
    private func plotData() {
        // Redraw grid
        gridLayer = createGridLayer()
        layer.addSublayer(gridLayer)
        axesLayer = createAxesLayer()
        layer.insertSublayer(axesLayer, above: gridLayer)
        
        // Plot data
        plotLayer = createPlotLayer()
        layer.insertSublayer(plotLayer, above: gridLayer)
    }
    
    // MARK: - Set up labels
    
    private func addLabels() {
        addXLabel()
        addYLabel()
    }
    
    private func addXLabel() {
        let label = UILabel()
        label.text = "X variable"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        let xC = NSLayoutConstraint(item: label,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .left,
                                    multiplier: 1,
                                    constant: origin.x + xLength/2)
        let yC = NSLayoutConstraint(item: label,
                                    attribute: .centerY,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: origin.y + xAxisMargin/2)
        
        NSLayoutConstraint.activate([xC, yC])
    }
    
    private func addYLabel() {
        let label = UILabel()
        label.text = "Y variable"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.transform = CGAffineTransform(rotationAngle: CGFloat(3*M_PI/2))
        
        addSubview(label)
        
        let xC = NSLayoutConstraint(item: label,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .left,
                                    multiplier: 1,
                                    constant: yAxisMargin/2)
        let yC = NSLayoutConstraint(item: label,
                                    attribute: .centerY,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: origin.y - yLength/2)
        
        NSLayoutConstraint.activate([xC, yC])
    }
    
    // MARK: - Set up layers
    
    private func createAxesLayer() -> CAShapeLayer {
        let axesLayer = CAShapeLayer()
        let axesPath = CGMutablePath()
        
        axesPath.move(to: CGPoint(x: origin.x, y: origin.y - yLength))
        axesPath.addLine(to: origin)
        axesPath.addLine(to: origin + CGPoint(x: xLength, y: 0))
        
        axesLayer.path = axesPath
        axesLayer.strokeColor = axesColour.cgColor
        axesLayer.lineWidth = 1
        axesLayer.lineCap = kCALineCapSquare
        axesLayer.fillColor = UIColor.clear.cgColor
        
        return axesLayer
    }
    
    private func createGridLayer() -> CAShapeLayer {
        let gridLayer = CAShapeLayer()
        let gridPath = CGMutablePath()
        
        // Create columns
        for x in stride(from: origin.x + xPointInterval, to: origin.x + xLength + xPointInterval, by: xPointInterval) {
            gridPath.move(to: CGPoint(x: x, y: xAxisMargin))
            gridPath.addLine(to: CGPoint(x: x, y: xAxisMargin + yLength))
        }
        // Create rows
        for y in stride(from: origin.y - yPointInterval, to: origin.y - yLength - yPointInterval, by: -yPointInterval) {
            gridPath.move(to: CGPoint(x: yAxisMargin, y: y))
            gridPath.addLine(to: CGPoint(x: yAxisMargin + xLength, y: y))
        }
        
        gridLayer.path = gridPath
        gridLayer.strokeColor = gridColour.cgColor
        gridLayer.lineWidth = 1
        gridLayer.lineCap = kCALineCapSquare
        gridLayer.fillColor = UIColor.clear.cgColor
        
        return gridLayer
    }
    
    private func createPlotLayer() -> CAShapeLayer {
        let plotLayer = CAShapeLayer()
        let plotPath = CGMutablePath()
        
        // Move to first point
        plotPath.move(to: CGPoint(x: origin.x + xPointInterval * CGFloat(xData[0]), y: origin.y - yPointInterval * CGFloat(yData[0])))
        
        for i in 0..<xData.count {
            // Calculate next point
            let nextPoint = CGPoint(x: origin.x + xPointInterval * CGFloat(xData[i]), y: origin.y - yPointInterval * CGFloat(yData[i]))
            
            // Add line to next point
            plotPath.addLine(to: nextPoint)
        }
        
        plotLayer.path = plotPath
        plotLayer.strokeColor = xColour.cgColor
        plotLayer.lineWidth = 1
        plotLayer.lineCap = kCALineCapSquare
        plotLayer.fillColor = UIColor.clear.cgColor
        
        return plotLayer
    }
}
