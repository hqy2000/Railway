import Foundation
import PlaygroundSupport
typealias Train = TrainNode
let numberOfTrainsOnEachTrack: Int = 4
let blockCount: Int = 10
let maximumSpeed: Double = 50.0
let acceleration: Double = 50.0

var trains: [Train] = []

for _ in 0..<numberOfTrainsOnEachTrack {
    trains.append(Train(direction: .inBound, acceleration: acceleration, maximumSpeed: maximumSpeed))
    trains.append(Train(direction: .outBound, acceleration: acceleration, maximumSpeed: maximumSpeed))
}
PlaygroundPage.current.liveView = SystemViewController()

(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(trains: trains, blockCount: blockCount)
