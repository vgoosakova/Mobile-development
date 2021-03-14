//
//  Lab2ViewController.swift
//  Mobile development
//
//  Created by Viktory  on 25.02.2021.
//

import UIKit

class Lab2ViewController: UIViewController {
    
    @IBOutlet weak var drawView: DrawView!
    
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
                case 0:
                    drawView.state = .chart
                case 1:
                    drawView.state = .graphic
                default:
                    break
                }
                drawView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
