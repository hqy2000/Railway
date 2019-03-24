//
//  StationNode.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SpriteKit

class StationNode: SKShapeNode {
    override init() {
        super.init()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -15, y: 10))
        path.addLine(to: CGPoint(x: 15, y: 10))
        path.addLine(to: CGPoint(x: 15, y: -10))
        path.addLine(to: CGPoint(x: -15, y: -10))
        path.closeSubpath()
        
        self.path = path
        self.fillColor = UIColor.white
        self.lineWidth = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
