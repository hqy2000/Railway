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
    
    /**
     Place a train on the track from the list.
     - Parameter for: The direction of the track that you want to place the train.
     */
    private func placeTrains(for direction: TrackNode.Direction) {
        let trains = self.trainsToPlace.filter { (train) -> Bool in
            return train.direction == direction
        }
        if trains.count == 0 {
            return
        }
        let train = trains[0]

        let path = self.trackNode.getPath(for: train.direction)
        let followPath = SKAction.follow(path, asOffset: true, orientToPath: true, speed: 40) // Let the train follow the track.
        /*
         followPath.timingFunction = { t in
         return powf(t, 3)
         }
         */
       
        train.position.y = self.verticalOffset
        
        if direction == .inBound {
            train.position.x = 0
            train.zRotation = 1.5 * .pi
            train.run(followPath)
        } else {
            train.position.x = 120
            train.position.y -= 15
            train.zRotation = 0.5 * .pi
            train.run(followPath.reversed()) // Outbound trains move in a opposite direction.
        }
        self.trainsToPlace.remove(at: self.trainsToPlace.firstIndex(of: train)!)
    }
}
