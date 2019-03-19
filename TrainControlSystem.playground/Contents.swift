//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


let trains = [
    TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: 100),
    TrainNode(direction: .outBound, acceleration: 0, maximumSpeed: 100),
    TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: 100),
    TrainNode(direction: .outBound, acceleration: 0, maximumSpeed: 100),
    TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: 100),
    TrainNode(direction: .outBound, acceleration: 0, maximumSpeed: 100)
]

let train = TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: 100)

// Present the view controller in the Live View window
// PlaygroundPage.current.liveView = GameViewController(train: train)

PlaygroundPage.current.liveView = GameViewController(trains: trains, blockCount: 15)
