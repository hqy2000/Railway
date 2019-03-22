import Foundation
import PlaygroundSupport
typealias Train = TrainNode

let blockCount: Int = 10
let trains: [Train] = [
    Train(direction: .inBound, acceleration: 10.0, maximumSpeed: 100),
    Train(direction: .outBound, acceleration: 30.0, maximumSpeed: 50)
]
PlaygroundPage.current.liveView = SystemViewController()
(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(trains: trains, blockCount: blockCount)
