import Foundation
import PlaygroundSupport
import UIKit

extension SystemViewController: PlaygroundLiveViewMessageHandler {
    // fatalErrors are used for debug.
    public func receive(_ message: PlaygroundValue) {
        guard case let .dictionary(message) = message else {
            return
            // fatalError("Message format is incorrect")
        }
        
        if case let .array(train)? = message["train"] {
            if let trainNode = self.getTrain(train) {
                self.restartSimulation(train: trainNode)
            } else {
                return
                // fatalError("Cannot resolve train.")
            }
        } else if case let .array(trains)? = message["trains"] {
            guard case let .integer(blockCount)? = message["blockCount"] else {
                return
                // fatalError("Blockcount is not specified.")
            }
            var trainNodes: [TrainNode] = []
            for train in trains {
                if case let .array(trainArray) = train, let trainNode = self.getTrain(trainArray) {
                    trainNodes.append(trainNode)
                } else {
                    return
                    // fatalError("Cannot resolve trains.")
                }
            }
            self.restartSimulation(trains: trainNodes, blockCount: blockCount)
        } else {
            return
            // fatalError("No trains.")
        }
    }
    
    private func getTrain(_ message: [PlaygroundValue]) -> TrainNode? {
        guard case let .integer(directionRawValue) = message[0] else {
            return nil
        }
        let direction = TrackNode.Direction(rawValue: directionRawValue)!
        guard case let .floatingPoint(acceleration) = message[1] else {
            return nil
        }
        guard case let .floatingPoint(maximumSpeed) = message[2] else {
            return nil
        }
        return TrainNode(direction: direction, acceleration: acceleration, maximumSpeed: maximumSpeed)
    }
}
