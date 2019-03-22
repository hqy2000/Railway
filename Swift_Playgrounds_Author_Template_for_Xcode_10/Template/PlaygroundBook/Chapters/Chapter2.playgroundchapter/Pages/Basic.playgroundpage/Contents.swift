//#-hidden-code
import Foundation
import PlaygroundSupport
typealias Train = TrainNode
//#-end-hidden-code
/*:
 # Automatic Block Signaling
 
 Automatic Block Signaling is an advanced way used in our daily life, especially for double track railways. It divided the track into small blocks. When the train in on a block, it was marked as used so other trains cannot enter the block until the train moves into the next block. Also, other trains on a few blocks after the train will be required to slow down to prevent collision.
 
 Now you have the control of how many trains that will run on each track, and how many blocks are available on each track. The train will only be placed if there is a space. If the number of people transferred per hour is represented in red, it means that not all trains are on the track. The train will move in an opposite direction after it reaches a station.
 
 In this simulation, blocks that are occupied by the train is represented in red, blocks where the train needs to slow down is marked in yellow, and blocks which trains can pass in full speed are presented in green.
 
 Try changing the parameters and see how it would affect the efficiency.
 */
let numberOfTrainsOnEachTrack: Int = /*#-copy-source(numberOfTrainsOnEachTrack)*//*#-editable-code*/4/*#-end-editable-code*//*#-end-copy-source*/ // This is the number of the trains that will be placed on each track.
let blockCount: Int = /*#-copy-source(blockCount)*//*#-editable-code*/10/*#-end-editable-code*//*#-end-copy-source*/ // This is the number of the signal blocks available on each track.
//#-hidden-code
let maximumSpeed: Double = 40.0
let acceleration: Double = 0.0

var trains: [PlaygroundValue] = []

for _ in 0..<numberOfTrainsOnEachTrack {
    trains.append(PlaygroundValue.array([.integer(1), .floatingPoint(acceleration), .floatingPoint(maximumSpeed)]))
    trains.append(PlaygroundValue.array([.integer(-1), .floatingPoint(acceleration), .floatingPoint(maximumSpeed)]))
}
guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
    fatalError("Always-on live view not configured in this page's LiveView.swift.")
}
remoteView.send(.dictionary(["trains": .array(trains), "blockCount": .integer(blockCount)]))

//#-end-hidden-code
//: [Next](@next)
