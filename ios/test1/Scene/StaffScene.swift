//
//  StaffScene.swift
//  test1
//
//  Created by hqy2000 on 2019/3/17.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SpriteKit

class StaffScene: AbstractScene {
    
    init(size: CGSize, train: TrainNode) {
        super.init(size: size)
        self.addTrainToPlace(train)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.trackNode = TrackNode(type: .single)
        super.didMove(to: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        self.placeTrains(for: .inBound)
        self.placeTrains(for: .outBound)
    }
    
    private func placeTrains(for direction: TrackNode.Direction) {
        let trains = self.trainsToPlace.filter { (train) -> Bool in
            return train.direction == direction
        }
        if trains.count == 0 {
            return
        }
        let train = trains[0]
        self.addChild(train)
        self.trainsOnTrack.append(train)
        let followPath = SKAction.follow(self.trackNode.getPath(for: train.direction), asOffset: false, orientToPath: true, speed: 40)
        /*
         followPath.timingFunction = { t in
         return powf(t, 3)
         }
         */
        if direction == .inBound {
            train.run(followPath)
        } else {
            train.run(followPath.reversed())
        }
        self.trainsToPlace.remove(at: 0)
    }
}
