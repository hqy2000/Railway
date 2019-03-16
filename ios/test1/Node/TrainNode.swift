//
//  TrainNode.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SpriteKit

class TrainNode: SKShapeNode {
    override init() {
        super.init()
        let line = CGMutablePath()
        /*
        line.addArc(center: CGPoint(x: -2.7, y: 0), radius: 2.5, startAngle: 2 * CGFloat.pi, endAngle: 0 * CGFloat.pi, clockwise: true)
        line.addArc(center: CGPoint(x: 2.7, y: 0), radius: 2.5, startAngle: 2 * CGFloat.pi, endAngle: 0 * CGFloat.pi, clockwise: true)
        line.move(to: CGPoint(x: -6, y: 2.5))
        line.addLine(to: CGPoint(x: 6, y: 2.5))
        line.addLine(to: CGPoint(x: 6, y: 8))
        line.addLine(to: CGPoint(x: -6, y: 8))
        */
        line.move(to: CGPoint(x: -2.5, y: 0.0))
        line.addLine(to: CGPoint(x: 2.5, y: 0.0))
        line.addLine(to: CGPoint(x: 2.5, y: 10.0))
        line.addLine(to: CGPoint(x: -7.0, y: 3.0))
        line.addLine(to: CGPoint(x: -2.5, y: 3.0))
        line.closeSubpath()
        self.fillColor = .red
        self.lineWidth = 0
        self.path = line
        //self.zRotation = .pi * 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
