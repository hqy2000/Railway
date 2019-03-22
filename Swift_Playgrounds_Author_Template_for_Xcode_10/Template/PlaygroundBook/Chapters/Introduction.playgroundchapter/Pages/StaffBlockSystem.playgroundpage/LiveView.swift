import UIKit
import PlaygroundSupport

let train = TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: maximumSpeed)
PlaygroundPage.current.liveView = SystemViewController(train: train)
