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
    public let direction: TrackNode.Direction
    public var maximumSlowSpeed: Double {
        get {
            return self.maximumSpeed / 5
        }
    }
    public let maximumSpeed: Double
    public let acceleration: Double
    
    public var velocity: Double = 0.0
    public var status: Status = .stopped
    
    init(direction: TrackNode.Direction = .inBound, acceleration: Double = 0.0, maximumSpeed: Double = 20.0) {
        self.direction = direction
        self.acceleration = acceleration
        self.maximumSpeed = maximumSpeed
        super.init()
        let line = CGMutablePath()
        line.move(to: CGPoint(x: -2.5, y: 0.0))
        line.addLine(to: CGPoint(x: 2.5, y: 0.0))
        line.addLine(to: CGPoint(x: 2.5, y: 10.0))
        line.addLine(to: CGPoint(x: -7.0, y: 3.0))
        line.addLine(to: CGPoint(x: -2.5, y: 3.0))
        line.closeSubpath()
        self.fillColor = .gray
        self.lineWidth = 0
        self.path = line
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Status {
        case fast
        case slow
        case stopped
    }
    
    public var reversed: TrainNode {
        get {
            return TrainNode(direction: self.direction, acceleration: self.acceleration, maximumSpeed: self.maximumSpeed)
        }
    }
}
