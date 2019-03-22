//#-hidden-code
import Foundation
import PlaygroundSupport
typealias Train = TrainNode
//#-end-hidden-code
/*:
 # Playground
 
 Now you can try to design your own trains to run. Try adding trains with different specifications to the array to see how it would change the effieciency. Note that the inbound direction is from left to right, while the outbound direction is from right to left.
 */
let blockCount: Int = /*#-editable-code*/10/*#-end-editable-code*/ // This is the number of the signal blocks available on each track.
let trains: [Train] = [
    //#-editable-code
    //#-code-completion(identifier, show, Train(direction:acceleration:maximumSpeed))
    Train(direction: .inBound, acceleration: 10.0, maximumSpeed: 100),
    Train(direction: .outBound, acceleration: 20.0, maximumSpeed: 50)
    //#-end-editable-code
]
//#-hidden-code
PlaygroundPage.current.liveView = SystemViewController()

(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(trains: trains, blockCount: blockCount)
//#-end-hidden-code
//: [Next](@next)
