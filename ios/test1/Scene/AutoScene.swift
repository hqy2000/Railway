//
//  GameScene.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import SpriteKit
import GameplayKit

class AutoScene: AbstractScene {
    private var blockCount: Int = 15

    private var inBoundBlocks: [BlockNode] = []
    private var outBoundBlocks: [BlockNode] = []
    private let trainCount: Int = 5
    private var blockLength: Int {
        get {
            return self.trackNode.range * 2 / self.blockCount
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let length = self.trackNode.range * 2
        for i in 1...self.blockCount {
            let end = -self.trackNode.range + length / blockCount * i
            let block = BlockNode(startsAt: CGFloat(end - length / blockCount), endsAt: CGFloat(end))
            block.position.y = 15
            self.addChild(block)
            self.inBoundBlocks.append(block)
            
            let block1 = BlockNode(startsAt: CGFloat(end - length / blockCount), endsAt: CGFloat(end))
            block1.position.y = -15
            self.addChild(block1)
            self.outBoundBlocks.append(block1)
        }
        
        self.outBoundBlocks.reverse()
        
        for _ in 0..<self.trainCount {
            self.placeTrain(forDirection: .inBound)
            self.placeTrain(forDirection: .outBound)
        }
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        self.refreshBlocks(currentTime, forDirection: .inBound)
        self.refreshBlocks(currentTime, forDirection: .outBound)
        super.update(currentTime)
    }
    
    private func refreshBlocks(_ currentTime: TimeInterval, forDirection direction: TrackNode.Direction) {
        if self.lastCountTime == 0 || currentTime - self.lastCountTime == 0 {
            return
        }
        var status: [Int] = []
        for _ in 1...(self.blockCount + 4) {
            status.append(-1)
        }
        let trains = self.trainsOnTrack.filter { (train) -> Bool in
            return train.direction == direction
        }
        for (index, train) in trains.enumerated() {
            var position = Int(train.position.x) + self.trackNode.range + 10
            if direction == .outBound {
                position = self.trackNode.range - Int(train.position.x)
            }
            let i = position / self.blockLength
            
            if i >= 0 && i < self.blockCount + 4 {
                status[i] = index
            }
        }
        
        if status[self.blockCount + 2] == -1 {
            status[self.blockCount + 2] = -2 // Occupy last to make the trains slow down
        }
        
        if status[self.blockCount + 3] == -1 {
            status[self.blockCount + 3] = -2 // Occupy last to make the trains slow down
        }
        
        let timePassed = currentTime - self.lastRefreshTime
        for (index, train) in trains.enumerated() {
            if let i = status.firstIndex(of: index) {
                if i < self.blockCount + 1 {
                    if status[i + 1] != -1 {
                        train.status = .stopped
                    } else if status[i + 2] != -1 || status[i + 3] != -1 {
                        train.status = .slow
                    } else {
                        train.status = .fast
                    }
                } else {
                    train.status = .fast
                }
                
            } else {
                train.status = .fast
            }
            
            var multiplier = 1.0
            if train.direction == .outBound {
                multiplier = -1.0
            }

            if train.maximumAcceleration != 0 {
                switch train.status {
                case .slow:
                    if train.velocity > train.maximumSlowSpeed {
                        multiplier = multiplier * -1.0
                    } else if train.velocity < train.maximumSlowSpeed {
                        multiplier = multiplier * 1.0
                    } else {
                        multiplier = multiplier * 0
                    }
                case .fast:
                    if train.velocity > train.maximumSpeed {
                        multiplier = multiplier * -1.0
                    } else if train.velocity < train.maximumSpeed {
                        multiplier = multiplier * 1.0
                    } else {
                        multiplier = 0
                    }
                case .stopped:
                    if train.velocity > train.maximumSpeed {
                        multiplier = multiplier * -1.0
                    } else {
                        multiplier = 0
                    }
                }
                
                
                train.velocity += train.maximumAcceleration * timePassed * multiplier
                train.position.x = train.position.x + CGFloat(train.velocity * timePassed)
            } else {
                switch train.status {
                case .slow:
                    train.velocity = train.maximumSlowSpeed
                case .fast:
                    train.velocity = train.maximumSpeed
                case .stopped:
                    train.velocity = 0.0
                }
                
                train.position.x = train.position.x + CGFloat(train.velocity * timePassed * multiplier)
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
                self.inBoundBlocks[i].switchStatus(to: blockStatus[i])
            } else {
                self.outBoundBlocks[i].switchStatus(to: blockStatus[i])
            }
            
        }
    }
}
