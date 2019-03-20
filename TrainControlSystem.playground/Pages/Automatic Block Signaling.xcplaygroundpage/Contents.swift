//: [Previous](@previous)

import Foundation
import PlaygroundSupport
typealias Train = TrainNode

let numberOfTrainsOnEachTrach: Int = 4
let blockCount: Int = 10
let maximumSpeed: Double = 100.0
let acceleration: Double = 0.0

var trains: [Train] = []

for _ in 0..<numberOfTrainsOnEachTrach {
    trains.append(Train(direction: .inBound, acceleration: acceleration, maximumSpeed: maximumSpeed))
    trains.append(Train(direction: .outBound, acceleration: acceleration, maximumSpeed: maximumSpeed))
}
PlaygroundPage.current.liveView = SystemViewController(trains: trains, blockCount: blockCount)


//: [Next](@next)
