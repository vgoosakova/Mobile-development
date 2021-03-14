//
//  DrawView.swift
//  Mobile development
//
//  Created by Viktory  on 05.03.2021.
//

import UIKit

class DrawView: UIView {
    enum State {
        case graphic
        case chart
    }
    
    var state: State = .chart

    let unit = 10.0

    var width: Double {
        return Double(frame.width)
    }
    
    var height: Double {
        return Double(frame.height)
    }
    
    
    var unitX: Double {
        return Double(frame.width * 0.02)
    }
    
    var unitY: Double {
        return Double(frame.height * 0.05)
    }
         
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        self.backgroundColor = UIColor.white
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func draw(_ rect: CGRect) {
        switch state {
        case .chart:
            drawAxis()
            drawGraphic()
        case .graphic:
            drawChart()
            break
        }
    }
    
    func drawChart() {
        let units: [DiagramUnit] = [DiagramUnit(value: 0.8, color: .blue),
                                    DiagramUnit(value: 0.05, color: .brown),
                                    DiagramUnit(value: 0.05, color: .cyan),
                                    DiagramUnit(value: 0.1, color: .orange)]
        
        var lastAngle: CGFloat = 0
        
        units.forEach { unit in
                    let path = UIBezierPath()
                    
                    let endAngle: CGFloat = lastAngle + CGFloat(unit.value * 2 * Double.pi)
                    let radius = frame.width / 3
                    
                    path.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: radius, startAngle: lastAngle, endAngle: endAngle, clockwise: true)
                    
                    path.lineWidth = radius / 1.5
                    unit.color.setStroke()
                    path.stroke()
                    
                    lastAngle = endAngle
                }
        
        struct DiagramUnit {
                
                let value: Double
                let color: UIColor
            }
    }
    
    
    func drawGraphic() {
        let chartPath = UIBezierPath()
        
        chartPath.lineWidth = 1
        UIColor.green.setStroke()
        
        chartPath.move(to: CGPoint(x: xScaling(point: -2 * Double.pi),
                              y: yScaling(point: 0)))
        for x in stride(from: -2 * Double.pi, to: 2 * Double.pi, by: 0.05){
            chartPath.addLine(to: CGPoint(x: xScaling(point: x), y: yScaling(point: sin(x))))
        }
        
        chartPath.stroke()
    }
    
    func xScaling(point: Double) -> Double {
        return point * (width - 2 * unit) / (Double.pi * 4) + width / 2

    }
    
    func yScaling(point: Double) -> Double {
        return point * (height - 2 * unit) / (Double.pi * 4) + height / 2

    }
    
    func drawAxis(){
        let path = UIBezierPath()
        
        path.lineWidth = 1
        UIColor.black.setStroke()
        
        path.move(to: CGPoint(x: width / 2, y: unit))
        path.addLine(to: CGPoint(x: width / 2, y: height - unit))
        
        path.move(to: CGPoint(x: unit, y: height / 2))
        path.addLine(to: CGPoint(x: width - unit, y: height / 2))
        
        path.move(to: CGPoint(x: width - unit, y: height / 2))
        path.addLine(to: CGPoint(x: width - 2 * unit, y: height / 2 - 0.5 * unit))
        path.move(to: CGPoint(x: width - unit, y: height / 2))
        path.addLine(to: CGPoint(x: width - 2 * unit, y: height / 2 + 0.5 * unit))
        
        path.move(to: CGPoint(x: width / 2, y: unit))
        path.addLine(to: CGPoint(x: width / 2 + 0.5 * unit, y: 2 * unit))
        path.move(to: CGPoint(x: width / 2, y: unit))
        path.addLine(to: CGPoint(x: width / 2 - 0.5 * unit, y: 2 * unit))
        
        path.move(to: CGPoint(x: width / 2 - 5, y: -1 * (height - 2 * unit) / (Double.pi * 4) + height / 2))
        path.addLine(to: CGPoint(x: width / 2 + 5, y: -1 * (height - 2 * unit) / (Double.pi * 4) + height / 2))

        path.move(to: CGPoint(x: (width - 2 * unit) / (Double.pi * 4) + width / 2, y: height / 2 - 5))
        path.addLine(to: CGPoint(x: (width - 2 * unit) / (Double.pi * 4) + width / 2, y: height / 2 + 5))
        
        path.stroke()
        
    }
}
