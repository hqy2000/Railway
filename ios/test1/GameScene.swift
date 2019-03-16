//
//  GameScene.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?

    private var blockCount: Int = 10
    private var trains: [TrainNode] = []
    private var blocks: [BlockNode] = []
    private var track: TrackNode = TrackNode(type: .single)
    
    override func didMove(to view: SKView) {
        let line = TrackNode(type: .single)
        self.track = line
        let station1 = StationNode()
        let station2 = StationNode()
        let train = TrainNode()
        self.addChild(line)
        self.addChild(station1)
        self.addChild(station2)
        station1.position.x = -100
        station2.position.x = 100
        
        let length = line.range * 2
        for i in 1...self.blockCount {
            let end = -line.range + length / blockCount * i
            let block = BlockNode(startsAt: CGFloat(end - length / blockCount), endsAt: CGFloat(end))
            self.addChild(block)
            self.blocks.append(block)
        }
        
        self.trains.append(train)
        self.addChild(train)
        
        let followPath = SKAction.follow(line.getPath(for: .inBound), asOffset: false, orientToPath: true, speed: 40)
        /*
        followPath.timingFunction = { t in
            return powf(t, 3)
        }
         */
        //train.tran
        train.run(SKAction.repeatForever(
            followPath
            //SKAction.rotate(byAngle: 1.0 * .pi, duration: 1.0)
        ))
        //train.zRotation = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.refreshBlocks()
    }
    
    private func refreshBlocks() {
        var status: [BlockStatus] = []
        for _ in 1...self.blockCount {
            status.append(.fast)
        }
        for train in self.trains {
            let position = Int(train.position.x)
            if position >= -self.track.range && position < self.track.range {
                let index = (position + self.track.range) / (self.track.range * 2 / self.blockCount)
                status[index] = .stop
                if(index >= 1) {
                    status[index-1] = .slow
                }
                if(index >= 2) {
                    status[index-2] = .slow
                }
            }
        }
        for i in 1...self.blockCount {
            self.blocks[i-1].switchStatus(to: status[i-1])
        }
    }
}
