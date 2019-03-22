/*:
 Railway serves as an important way of transport in our daily life. Have you ever thought about what controls the train to work? How trains can prevent from colliding into each other? In this book, you will understand how the railway signal system works.
 */
import PlaygroundSupport

PlaygroundPage.current.liveView = SystemViewController()

(PlaygroundPage.current.liveView as! SystemViewController).restartSimulation(train: TrainNode(direction: .inBound, acceleration: 10, maximumSpeed: 50))
//: [Next](@next)
