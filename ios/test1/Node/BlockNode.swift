//
//  BlockNode.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SpriteKit

class BlockNode: SKShapeNode {
    init(startsAt start: CGFloat, endsAt end: CGFloat) {
        super.init()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: start, y: 2.5))
        path.addLine(to: CGPoint(x: end, y: 2.5))
        path.addLine(to: CGPoint(x: end, y: -2.5))
        path.addLine(to: CGPoint(x: start, y: -2.5))
        path.closeSubpath()
        self.path = path
        self.switchStatus(to: .stop)
        self.lineWidth = 0
    }
    
    public func switchStatus(to status: BlockStatus) {
        switch status {
        case .fast:
            self.fillColor = .green
        case .slow:
            self.fillColor = .yellow
        case .stop:
            self.fillColor = .red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
enum BlockStatus {
    case stop
    case slow
    case fast
}

enum BlockMode {
    case none
    case staff
    case auto
    case cbtc
}
