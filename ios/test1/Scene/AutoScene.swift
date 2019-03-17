//
//  GameScene.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import SpriteKit
import GameplayKit

class AutoScene: SKScene {
    private var blockCount: Int = 10
    private var trains: [TrainNode] = []
    private var blocks: [BlockNode] = []
    private var outBoundBlocks: [BlockNode] = []
    
    
    private var track: TrackNode = TrackNode(type: .single)
    
    private var lastTime: TimeInterval = 0
    
    private var blockLength: Int {
        get {
            return self.track.range * 2 / self.blockCount
        }
    }
    
    override func didMove(to view: SKView) {
        let line = TrackNode(type: .double)
        self.track = line
        let station1 = StationNode()
        let station2 = StationNode()
       
        self.addChild(line)
        self.addChild(station1)
        self.addChild(station2)
        station1.position.x = -100
        station2.position.x = 100
        
        let length = line.range * 2
        for i in 1...self.blockCount {
            let end = -line.range + length / blockCount * i
            let block = BlockNode(startsAt: CGFloat(end - length / blockCount), endsAt: CGFloat(end))
            block.position.y = 15
            self.addChild(block)
            self.blocks.append(block)
            
            let block1 = BlockNode(startsAt: CGFloat(end - length / blockCount), endsAt: CGFloat(end))
            block1.position.y = -15
            self.addChild(block1)
            self.outBoundBlocks.append(block1)
        }
        
        self.outBoundBlocks.reverse()
        
        self.placeTrain(forDirection: .inBound)
        self.placeTrain(forDirection: .outBound)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.placeTrain(forDirection: .inBound)
            self.placeTrain(forDirection: .outBound)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.placeTrain(forDirection: .inBound)
            self.placeTrain(forDirection: .outBound)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.placeTrain(forDirection: .inBound)
            self.placeTrain(forDirection: .outBound)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.placeTrain(forDirection: .inBound)
            self.placeTrain(forDirection: .outBound)
        }
        
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
    
    private func placeTrain(forDirection direction: TrackNode.Direction) {
        let train = TrainNode(direction: direction)
        if direction == .inBound {
            train.position.x = -120
            train.position.y = 15
            train.zRotation = 1.5 * .pi
        } else {
            train.position.x = 120
            train.position.y = -15
            train.zRotation = 0.5 * .pi
        }
        self.trains.append(train)
        self.addChild(train)
    }
    
    private func gc() {
        var trainsToRemove: [Int] = []
        for (index, train) in trains.enumerated() {
            if train.direction == .inBound && train.position.x > 120 {
                train.removeFromParent()
                trainsToRemove.append(index)
                self.placeTrain(forDirection: .outBound)
            } else if train.direction == .outBound && train.position.x < -120 {
                train.removeFromParent()
                trainsToRemove.append(index)
                self.placeTrain(forDirection: .inBound)
            }
            //Do not remove while iterating.
        }
        for i in trainsToRemove.reversed() {
            self.trains.remove(at: i)
        }
    }
    override func update(_ currentTime: TimeInterval) {
        self.refreshBlocks(currentTime, forDirection: .inBound)
        self.refreshBlocks(currentTime, forDirection: .outBound)
        self.gc()
        self.lastTime = currentTime
    }
    
    private func refreshBlocks(_ currentTime: TimeInterval, forDirection direction: TrackNode.Direction) {
        var status: [Int] = []
        for _ in 1...(self.blockCount + 2) {
            status.append(-1)
        }
        let trains = self.trains.filter { (train) -> Bool in
            return train.direction == direction
        }
        for (index, train) in trains.enumerated() {
            var position = Int(train.position.x) + self.track.range
            if direction == .outBound {
                position = self.track.range - Int(train.position.x)
                //print(position)
            }
            let i = position / self.blockLength
            
            if i >= 0 && i < self.blockCount + 2 {
                status[i] = index
            }
            /*
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
            */
        }
        
        if self.lastTime != 0 {
            let timePassed = currentTime - self.lastTime

            let acceleration = 5.0
            
            for (index, train) in trains.enumerated() {
                if let i = status.firstIndex(of: index) {
                    if i < self.blockCount - 1 {
                        if status[i + 1] != -1 {
                            train.trainSpeed = 0
                            //train.status = .deceleratingToStop
                        } else if status[i + 2] != -1 || status[i + 3] != -1 {
                            train.trainSpeed = 5
                            // train.status = .deceleratingToSlowMode
                        } else {
                            train.trainSpeed = 20
                        }
                    } else {
                        train.trainSpeed = 20
                    }
                    
                } else {
                    train.trainSpeed = 20.0
                }
                
                
                
                
                var multiplier = 1.0
                if train.direction == .outBound {
                    multiplier = -1.0
                }
                //print(status)
                
                /*
                switch train.status {
                case .acceleratingToFastMode, .acceleratingToSlowMode:
                    train.trainSpeed = train.trainSpeed + acceleration * timePassed
                case .deceleratingToStop, .deceleratingToSlowMode:
                    train.trainSpeed = train.trainSpeed - acceleration * timePassed
                default:
                    break
                }
                */
                
                train.position.x = train.position.x + CGFloat(train.trainSpeed * timePassed * multiplier)
                
            }
        }
        
        var blockStatus: [BlockStatus] = []
        for i in 0..<(self.blockCount) {
            if status[i] != -1 {
                blockStatus.append(.stop)
            } else if status[i+1] != -1 || status[i+2] != -1 {
                blockStatus.append(.slow)
            } else {
                blockStatus.append(.fast)
            }
        }
        
        
        for i in 0..<self.blockCount {
            if direction == .inBound {
                self.blocks[i].switchStatus(to: blockStatus[i])
            } else {
                self.outBoundBlocks[i].switchStatus(to: blockStatus[i])
            }
            
        }
    }
}
