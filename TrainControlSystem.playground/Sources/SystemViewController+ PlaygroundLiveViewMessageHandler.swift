import Foundation
import PlaygroundSupport

extension SystemViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard case let .dictionary(message) = message else {
            return
        }
        
        if case let .array(train) = message["train"] {
            if let trainNode = self.getTrain(train) {
                self.restartSimulation(train: trainNode)
            }
        } else if case let .array(trains) = message["trains"] {
            guard case let .integer(blockCount) = message["blockCount"] else {
                return
            }
            for train in trains {
                let trains: [TrainNode] = []
                if let trainNode = self.getTrain(train) {
                    trains.append(trainNode)
                }
            }
            self.restartSimulation(trains: trains, blockCount: blockCount)
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
