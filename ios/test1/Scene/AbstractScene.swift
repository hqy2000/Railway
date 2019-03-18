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
    internal var lastCountTime: TimeInterval = 0
    
    internal var lastRefreshTime: TimeInterval = 0
    
    internal let countLabelNode = SKLabelNode(text: "160 people / hour")
    internal let remainLabelNode = SKLabelNode(text: "5 cars remain")
    internal var trackNode: TrackNode = TrackNode(type: .double)
    
    
    override func didMove(to view: SKView) {
        let track = TrackNode(type: .double)
        self.trackNode = track
        self.addChild(trackNode)
        
        let station1 = StationNode()
        let station2 = StationNode()
        station1.position.x = -100
        station2.position.x = 100
        self.addChild(station1)
        self.addChild(station2)
        
        self.addChild(self.countLabelNode)
        self.countLabelNode.position.x = 200
        self.countLabelNode.position.y = 200
        
        self.addChild(self.remainLabelNode)
        self.remainLabelNode.position.x = 200
        self.remainLabelNode.position.y = 150
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.lastRefreshTime = currentTime
        self.cleanTrack(currentTime)
        self.placeInBoundTrains()
        self.placeOutBoundTrains()
    }
    
    internal func placeInBoundTrains() {
        let inRegioinTrains = self.trainsOnTrack.filter({ (train) -> Bool in
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
    
    internal func placeOutBoundTrains() {
        let inRegioinTrains = self.trainsOnTrack.filter({ (train) -> Bool in
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
    
    internal func cleanTrack(_ currentTime: TimeInterval) {
        var trainsToRemove: [Int] = []
        for (index, train) in trainsOnTrack.enumerated() {
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
            self.trainsOnTrack.remove(at: i)
        }
        self.totalCount += trainsToRemove.count * 500
        let rate: Int = Int(Double(self.totalCount) / (currentTime - self.lastCountTime))
        self.countLabelNode.text = "\(rate) people / hour"
        self.remainLabelNode.text = "\(self.trainsToPlace.count) cars not shown"
    }
    
    internal func placeTrain(forDirection direction: TrackNode.Direction) {
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
        self.trainsToPlace.append(train)
    }
}
