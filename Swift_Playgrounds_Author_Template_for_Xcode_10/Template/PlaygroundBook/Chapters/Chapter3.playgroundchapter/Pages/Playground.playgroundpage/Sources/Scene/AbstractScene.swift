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
    /**
     The list of TrainNode that are currenly running on the track.
     */
    internal var trainsOnTrack: [TrainNode] = []
    /**
     The list of TrainNode that are waiting to be placed on the track.
     */
    internal var trainsToPlace: [TrainNode] = []
    /**
     The total count of passengers transferred.
     */
    internal var totalCount: Int = 0
    /**
     The starting time of the simulation.
     */
    internal var startTime: TimeInterval = 0
    /**
     Last time to update the trains.
     */
    internal var lastRefreshTime: TimeInterval = 0
    /**
     Last time to count the efficiency.
     */
    internal var lastCountTime: TimeInterval = 0
    /**
     The node to display the passengers transferred per hour.
     */
    internal let countLabelNode = SKLabelNode(text: "0000")
    /**
     The node to display how many TrainNodes are not yet placed.
     */
    internal let remainLabelNode = SKLabelNode(text: "5 cars remain")
    /**
     The node for the track.
     */
    internal var trackNode: TrackNode = TrackNode(type: .double)
    /**
     The vertical shift offset for all nodes.
     */
    internal let verticalOffset: CGFloat = 30.0
    
    
    override func didMove(to view: SKView) {
        let backgroundNode = SKSpriteNode(imageNamed: "background.jpg")
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode.size.width = self.size.width
        backgroundNode.size.height = self.size.height
        backgroundNode.zPosition = -100
        
        let backgroundMaskNode = SKSpriteNode(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5), size: self.size)
        backgroundMaskNode.zPosition = -99
        
        self.addChild(backgroundNode)
        self.addChild(backgroundMaskNode)
        
        self.trackNode.position.y = 0 + self.verticalOffset
        self.addChild(self.trackNode)
        
        let station1 = StationNode()
        let station2 = StationNode()
        station1.position.x = -100
        station1.position.y = 0 + self.verticalOffset
        station2.position.x = 100
        station2.position.y = 0 + self.verticalOffset
        self.addChild(station1)
        self.addChild(station2)
        
        let rectangleNode = SKShapeNode(rectOf: CGSize(width: 100, height: 40), cornerRadius: 5)
        rectangleNode.position.x = 0
        rectangleNode.position.y = -55 + self.verticalOffset
        self.addChild(rectangleNode)
        
        // self.countLabelNode.fontName = self.countLabelNode.fontName! + "-Bold"
        self.addChild(self.countLabelNode)
        self.countLabelNode.horizontalAlignmentMode = .center
        self.countLabelNode.position.y = -67 + self.verticalOffset
        self.countLabelNode.position.x = 0
        // self.addChild(self.remainLabelNode)
        // self.remainLabelNode.position.x = 100
        // self.remainLabelNode.position.y = 150
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
        self.totalCount += trainsToRemove.count * 500 // Assume each train can carry 500 passengers.
        if (currentTime - self.lastCountTime >= 0.5) { // Debounce.
            let rate: Int = Int(Double(self.totalCount) / (currentTime - self.startTime)) // Use per second in simulation to reflect per hour in reality.
            self.countLabelNode.text = "\(rate)"
            self.lastCountTime = currentTime
        }
        if self.trainsToPlace.count > 2 {
            self.countLabelNode.fontColor = UIColor.red
        } else if self.trainsToPlace.count > 0 {
            self.countLabelNode.fontColor = UIColor.yellow
        } else {
            self.countLabelNode.fontColor = UIColor.green
        }
        // self.remainLabelNode.text = "\(self.trainsToPlace.count) cars not shown"
    }
    
    /**
     Add a train to the list of the trains that will be later added on the track.
     */
    internal func addTrainToPlace(_ train: TrainNode) {
        self.trainsToPlace.append(train)
    }
}
