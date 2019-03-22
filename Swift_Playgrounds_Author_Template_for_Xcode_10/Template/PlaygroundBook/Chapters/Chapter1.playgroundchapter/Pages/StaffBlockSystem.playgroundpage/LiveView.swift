//#-hidden-code
import Foundation
import PlaygroundSupport

typealias Train = TrainNode
let maximumSpeed: Double = /*#-editable-code*/100/*#-end-editable-code*/ // This is the maximum speed of the train.
let train = Train(direction: .inBound, acceleration: 0, maximumSpeed: maximumSpeed)
PlaygroundPage.current.liveView = SystemViewController()

(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(train: train)
