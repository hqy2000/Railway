//
//  TrainManager.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SpriteKit

class TrainManger {
    private let blockType: BlockMode
    public var blockCount: Int = 1 {
        willSet {
            if self.blockType != .auto {
                fatalError("You cannot specify blocks on a non-auto mode!")
            }
        }
    }
    
    init(blockType type: BlockMode) {
        self.blockType = type
    }
}
