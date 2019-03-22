//#-hidden-code
import Foundation
import PlaygroundSupport

typealias Train = TrainNode
//#-end-hidden-code
/*:
 # Staff Block System
 One of the traditional ways is called stack block system. A symbol, which is often a ticket or a staff, is required for the train to run in a specific region. This is often used for single track railways, where only one train is allowed to run in a region.
 
 Now you can control the maximum speed of each train.
 
 Try changing the parameters and see how it would affect the efficiency. The number of people transferred per hour is presented in the box below the track.
 */
let maximumSpeed: Double = /*#-editable-code*/100/*#-end-editable-code*/
//#-hidden-code
let train = Train(direction: .inBound, acceleration: 0, maximumSpeed: maximumSpeed)
PlaygroundPage.current.liveView = SystemViewController()

(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(train: train)
//#-end-hidden-code

//: [Next](@next)
