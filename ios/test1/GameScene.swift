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
    
    private var lastTime: TimeInterval = 0
    
    private var blockLength: Int {
        get {
            return self.track.range * 2 / self.blockCount
        }
    }
    
    override func didMove(to view: SKView) {
        let line = TrackNode(type: .single)
        self.track = line
        let station1 = StationNode()
        let station2 = StationNode()
        let train = TrainNode(direction: .outBound)
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
        /*
        let followPathNew = SKAction.run {
            
        }
        let followPath = SKAction.follow(line.getPath(for: train.direction), asOffset: false, orientToPath: true, speed: 40)
        followPath.timingFunction = { t in
            return powf(t, 3)
        }
        train.run(SKAction.repeatForever(followPath)) {
            
        }
        */
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.refreshBlocks(currentTime)
    }
    
    private func refreshBlocks(_ currentTime: TimeInterval) {
        var status: [BlockStatus] = []
        for _ in 1...self.blockCount {
            status.append(.fast)
        }
        for train in self.trains {
            let position = Int(train.position.x)
            if position >= -self.track.range && position < self.track.range {
                let index = (position + self.track.range) / self.blockLength
                status[index] = .stop
                if(index >= 1) {
                    status[index-1] = .slow
                }
                if(index >= 2) {
                    status[index-2] = .slow
                }
            } else {
                let position = (abs(position) - self.track.range) / self.blockLength
                switch position {
                case 0:
                    if train.position.x < 0 && train.direction == .outBound {
                        status[0] = .slow
                        status[1] = .slow
                    } else if train.position.x > 0 && train.direction == .inBound {
                        status[self.blockCount - 2] = .slow
                        status[self.blockCount - 1] = .slow
                    }
                    break
                case 1:
                    if train.position.x < 0 && train.direction == .outBound {
                        status[0] = .slow
                    } else if train.position.x > 0 && train.direction == .inBound {
                        status[self.blockCount - 1] = .slow
                    }
                    break
                default:
                    break
                }
            }
        }
        if self.lastTime != 0 {
            let timePassed = currentTime - self.lastTime

            let acceleration = 3.0
            
            for train in self.trains {
              
                var multiplier = 1.0
                if train.direction == .outBound {
                    multiplier = -1.0
                }
                
                switch train.status {
                case .acceleratingToFastMode, .acceleratingToSlowMode:
                    train.trainSpeed = train.trainSpeed + acceleration * timePassed
                case .deceleratingToStop, .deceleratingToSlowMode:
                    train.trainSpeed = train.trainSpeed - acceleration * timePassed
                default:
                    break
                }
                
                train.position.x = CGFloat(train.trainSpeed * timePassed * multiplier)
                
                if(train.position.x >= 120) {
                    train.direction = .inBound
                } else {
                    train.direction = .outBound
                }
                
            }
        }
        self.lastTime = currentTime
        
        for i in 1...self.blockCount {
            self.blocks[i-1].switchStatus(to: status[i-1])
        }
    }
}
