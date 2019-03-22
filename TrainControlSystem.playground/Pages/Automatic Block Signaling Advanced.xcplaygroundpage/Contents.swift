//#-hidden-code
import Foundation
import PlaygroundSupport
typealias Train = TrainNode
//#-end-hidden-code
/*:
 # Automatic Block Signaling
 
 Now you have additional control of the train. You can change the maximum speed, and the acceleration and the deceleration of the train. Try changing the parameters and see how it would affect the efficiency.
 
 */
let numberOfTrainsOnEachTrack: Int = /*#-editable-code*/4/*#-end-editable-code*/ // This is the number of the trains that will be placed on each track.
let blockCount: Int = /*#-editable-code*/10/*#-end-editable-code*/ // This is the number of the signal blocks available on each track.
let maximumSpeed: Double = /*#-editable-code*/100/*#-end-editable-code*/ // This is the maximum speed of each train.
let acceleration: Double = /*#-editable-code*/10/*#-end-editable-code*/ // This is the acceleration / deceleration of the train. If you want the train to speed up or slow down immediately, you can set this value to zero.
//#-hidden-code
var trains: [Train] = []

for _ in 0..<numberOfTrainsOnEachTrack {
    trains.append(Train(direction: .inBound, acceleration: acceleration, maximumSpeed: maximumSpeed))
    trains.append(Train(direction: .outBound, acceleration: acceleration, maximumSpeed: maximumSpeed))
}
PlaygroundPage.current.liveView = SystemViewController()

(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(trains: trains, blockCount: blockCount)
//#-end-hidden-code
//: [Next](@next)
