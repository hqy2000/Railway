//#-hidden-code
import Foundation
import PlaygroundSupport

typealias Train = TrainNode
//#-end-hidden-code
/*:
 # Staff Block System
 One of the traditional ways is called [Staff block system](glossary://staff%20block%20system). In railway, a track is divided into small regions called '[blocks](glossary://Signalling%20block%20system)'. 'Staff block system' is a type of the [manual block system](glossary://Manual%20block%20system). A symbol, which is often a ticket or a staff, is required for the train to run in a specific region. This is often used for single track railways, where only one train is allowed to run in a region.
 
 Now you can control the maximum speed of each train. Try changing the parameters and see how it would affect efficiency. T
 
 - Note:
 The number of people transferred per hour is presented in the box below the track.

 */
let maximumSpeed: Double = /*#-editable-code*/10/*#-end-editable-code*/
//#-hidden-code


guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
    fatalError("Always-on live view not configured in this page's LiveView.swift.")
}
remoteView.send(.dictionary(["train": .array([.integer(1), .floatingPoint(0), .floatingPoint(maximumSpeed)])]))
//#-end-hidden-code

//: [Next](@next)
