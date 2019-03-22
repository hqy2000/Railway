import Foundation
import PlaygroundSupport

typealias Train = TrainNode
let maximumSpeed: Double = 10
let train = Train(direction: .inBound, acceleration: 0, maximumSpeed: maximumSpeed)
PlaygroundPage.current.liveView = SystemViewController()
(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(train: train)
