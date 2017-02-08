//
//  GraphViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 08/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate test data
        var testXData: [Float] = []
        var testYData: [Float] = []
        
        for _ in 0..<20 {
            testXData.append(Float(arc4random_uniform(20-1))+1)
            testYData.append(Float(arc4random_uniform(20-1))+1)
        }
        
        let graphView = GraphView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        graphView.add(xData: testXData)
        graphView.add(yData: testYData)
        
        view.addSubview(graphView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
