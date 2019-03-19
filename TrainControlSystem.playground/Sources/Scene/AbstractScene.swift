//
//  AbstractScene.swift
//  test1
//
//  Created by hqy2000 on 2019/3/17.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SpriteKit

class AbstractScene: SKScene {
    internal var trainsOnTrack: [TrainNode] = []
    internal var trainsToPlace: [TrainNode] = []
    
    internal var totalCount: Int = 0
    internal var startTime: TimeInterval = 0
    
    internal var lastRefreshTime: TimeInterval = 0
    
    internal let countLabelNode = SKLabelNode(text: "160 people / hour")
    internal let remainLabelNode = SKLabelNode(text: "5 cars remain")
    internal var trackNode: TrackNode = TrackNode(type: .double)
    
    
    override func didMove(to view: SKView) {
        // let track = TrackNode(type: .single)
        // self.trackNode = track
        self.addChild(self.trackNode)
        
        let station1 = StationNode()
        let station2 = StationNode()
        station1.position.x = -100
        station2.position.x = 100
        self.addChild(station1)
        self.addChild(station2)
        
        self.addChild(self.countLabelNode)
        self.countLabelNode.position.x = 100
        self.countLabelNode.position.y = 200
        
        self.addChild(self.remainLabelNode)
        self.remainLabelNode.position.x = 100
        self.remainLabelNode.position.y = 150
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.startTime == 0 {
            self.startTime = currentTime - 0.1 // Prevent division by zero
        }
        self.lastRefreshTime = currentTime
        self.cleanTrack(currentTime)
    }
    
    /**
     Check whether a train has reached the end of the track.
     */
    internal func cleanTrack(_ currentTime: TimeInterval) {
        var trainsToRemove: [Int] = []
        for (index, train) in trainsOnTrack.enumerated() {
            if train.direction == .inBound && train.position.x > 120 {
                train.removeFromParent()
                trainsToRemove.append(index)
                self.addTrainToPlace(train.reversed)
            } else if train.direction == .outBound && train.position.x < -120 {
                train.removeFromParent()
                trainsToRemove.append(index)
                self.addTrainToPlace(train.reversed)
            }
            //Do not remove while iterating.
        }
        for i in trainsToRemove.reversed() {
            self.trainsOnTrack.remove(at: i)
        }
        self.totalCount += trainsToRemove.count * 500
        let rate: Int = Int(Double(self.totalCount) / (currentTime - self.startTime))
        self.countLabelNode.text = "\(rate) people / hour"
        self.remainLabelNode.text = "\(self.trainsToPlace.count) cars not shown"
    }
    
    /**
     Add a train to the list of the trains that will be later added on the track.
     */
    internal func addTrainToPlace(_ train: TrainNode) {
        if train.direction == .inBound {
            train.position.x = -120
            train.position.y = 15
            train.zRotation = 1.5 * .pi
        } else {
            train.position.x = 120
            train.position.y = -15
            train.zRotation = 0.5 * .pi
        }
        self.trainsToPlace.append(train)
    }
}
