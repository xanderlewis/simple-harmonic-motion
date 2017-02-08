//
//  GraphViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 08/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var graphView: GraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView = GraphView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        graphView.add(xData: generateTestData())
        graphView.add(yData: generateTestData())
        
        view.addSubview(graphView)
    }
    
    private func generateTestData() -> [Float] {
        var data: [Float] = []
        for _ in 0..<40 {
            data.append(Float(arc4random_uniform(40-1))+1)
        }
        return data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
