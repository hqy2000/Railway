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
    /**
     The number of the signal blocks available on each track.
     */
    private let blockCount: Int
    /**
     The array of BlockNode on the inbound track.
     */
    private var inBoundBlocks: [BlockNode] = []
    /**
     The array of BlockNode on the outbound track.
     */
    private var outBoundBlocks: [BlockNode] = []
    /**
     The length of each block.
     */
    private var blockLength: Int {
        get {
            return self.trackNode.range * 2 / self.blockCount
        }
    }
    
    init(size: CGSize, trains: [TrainNode], blockCount: Int) {
        self.blockCount = blockCount
        super.init(size: size)
        for train in trains {
            self.addTrainToPlace(train)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.trackNode = TrackNode(type: .double)
        super.didMove(to: view)
        let length = self.trackNode.range * 2
        for i in 1...self.blockCount { // Add blocks to the track
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
        
        self.outBoundBlocks.reverse() // Outbound blocks start from right to left.
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        self.refreshBlocks(currentTime, for: .inBound)
        self.refreshBlocks(currentTime, for: .outBound)
        super.update(currentTime)
        self.placeInBoundTrains()
        self.placeOutBoundTrains()
    }
    
    /**
     Place a train on the inbound track.
     */
    private func placeInBoundTrains() {
        let inRegioinTrains = self.trainsOnTrack.filter({ (train) -> Bool in // Check whether there is a train on the start of the track to prevent colision.
            return Int(train.position.x) < -self.trackNode.range
        })
        let trainsToPlace = self.trainsToPlace.filter { (train) -> Bool in
            return train.direction == .inBound
        }
        if inRegioinTrains.count == 0 && trainsToPlace.count > 0{
            self.addChild(trainsToPlace[0])
            self.trainsOnTrack.append(trainsToPlace[0])
            self.trainsToPlace.remove(at: self.trainsToPlace.firstIndex(of: trainsToPlace[0])!)
        }
    }
    
    /**
     Place a train on the outbound track.
     */
    private func placeOutBoundTrains() {
        let inRegioinTrains = self.trainsOnTrack.filter({ (train) -> Bool in // Same as above.
            return Int(train.position.x) > self.trackNode.range
        })
        let trainsToPlace = self.trainsToPlace.filter { (train) -> Bool in
            return train.direction == .outBound
        }
        if inRegioinTrains.count == 0 && trainsToPlace.count > 0{
            self.addChild(trainsToPlace[0])
            self.trainsOnTrack.append(trainsToPlace[0])
            self.trainsToPlace.remove(at: self.trainsToPlace.firstIndex(of: trainsToPlace[0])!)
        }
    }
    
    /**
     Refresh the status of the signal blocks and move the trains on the track.
     - Parameter for: The direction of the track that you want to place the train.
     */
    private func refreshBlocks(_ currentTime: TimeInterval, for direction: TrackNode.Direction) {
        if self.lastRefreshTime == 0.0 || currentTime - self.lastRefreshTime == 0.0 { // To prevent division by zero error.
            return
        }
        var status: [Int] = []
        for _ in 1...(self.blockCount + 4) { // 2 for the start region, and 2 for the end region. Each integer in this array represents the index of the train. -1 means empty.
            status.append(-1)
        }
        let trains = self.trainsOnTrack.filter { (train) -> Bool in // Get the trains on a specific track according to the direction.
            return train.direction == direction
        }
        for (index, train) in trains.enumerated() { // Match the position of each train into the index of the 'status' array.
            var position = Int(train.position.x) + self.trackNode.range + 10 // Trains have length. Assume it is 10.
            if direction == .outBound {
                position = self.trackNode.range - Int(train.position.x)
            }
            let i = position / self.blockLength
            
            if i >= 0 && i < self.blockCount + 4 { // Prevent out of bound error.
                status[i] = index
            }
        }
        
        if status[self.blockCount + 2] == -1 {
            status[self.blockCount + 2] = -2 // Make the train slow down when approaching to the station.
        }
        
        if status[self.blockCount + 3] == -1 {
            status[self.blockCount + 3] = -2 // Same as above
        }
        
        let timePassed = currentTime - self.lastRefreshTime
        for (index, train) in trains.enumerated() { // Check whether train can move in a fast speed, slow speed or the train needs to stop.
            if let i = status.firstIndex(of: index) {
                if i < self.blockCount + 1 {
                    if status[i + 1] != -1 {
                        train.status = .stopped
                    } else if status[i + 2] != -1 || status[i + 3] != -1 { // The train needs to slow down if there are trains two blocks ahead.
                        train.status = .slow
                    } else {
                        train.status = .fast
                    }
                } else {
                    train.status = .fast
                }
                
            } else {
                train.status = .slow // The train is not in the 'status' array, meaning it is at the beginning or the end of the track.
            }
            var multiplier = 1.0
            if train.direction == .outBound {
                multiplier = -1.0 // Outbound trains move in an opposite direction.
            }

            if train.acceleration != 0 { // The train can speed up or slow down immediately if acceleration is zero.
                switch train.status {
                case .slow:
                    if abs(train.velocity) > train.maximumSlowSpeed {
                        multiplier = multiplier * -1.0 // Slow down
                    } else if train.velocity < train.maximumSlowSpeed {
                        multiplier = multiplier * 1.0 // Speed up
                    } else {
                        multiplier = multiplier * 0.0 // Maintain
                    }
                case .fast:
                    if abs(train.velocity) > train.maximumSpeed {
                        multiplier = multiplier * -1.0
                    } else if train.velocity < train.maximumSpeed {
                        multiplier = multiplier * 1.0
                    } else {
                        multiplier = 0.0
                    }
                case .stopped:
                    multiplier = 0.0
                    train.velocity = 0.0 // Stop immediately.
                }
                
                
                train.velocity += train.acceleration * timePassed * multiplier // v = v0 + a * t
                train.position.x = train.position.x + CGFloat(train.velocity * timePassed) // x = x0 + v * t
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
        
        var blockStatus: [BlockNode.Status] = [] // Determine the color of the blocks according to the 'status' array.
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
