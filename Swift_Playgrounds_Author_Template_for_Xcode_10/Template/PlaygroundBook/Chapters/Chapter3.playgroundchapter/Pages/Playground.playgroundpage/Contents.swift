//#-hidden-code
import Foundation
import PlaygroundSupport
typealias Train = TrainNode
//#-end-hidden-code
/*:
 # Playground
 
 Now you can try to design your own trains to run. Try adding trains with different specifications to the array and see how it would affect effieciency.
 
 - Note:
 The inbound direction is from left to right, while the outbound direction is from right to left.
 */
let blockCount: Int = /*#-editable-code*/10/*#-end-editable-code*/ // This is the number of the signal blocks available on each track.
let trains: [Train] = [
    // Try to add, remove or edit trains in this array.
    //#-editable-code
    //#-code-completion(everything, hide)
    //#-code-completion(identifier, show, Train)
    Train(direction: .inBound, acceleration: 10.0, maximumSpeed: 100),
    Train(direction: .outBound, acceleration: 30.0, maximumSpeed: 50)
    //#-end-editable-code
]
//#-hidden-code
var trainData: [PlaygroundValue] = []
for train in trains {
    trainData.append(PlaygroundValue.array([.integer(train.direction.rawValue), .floatingPoint(train.acceleration), .floatingPoint(train.maximumSpeed)]))
}
guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
    fatalError("Always-on live view not configured in this page's LiveView.swift.")
}
remoteView.send(.dictionary(["trains": .array(trainData), "blockCount": .integer(blockCount)]))
//#-end-hidden-code
