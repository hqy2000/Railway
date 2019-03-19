//
//  GameViewController.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = SKView(frame: self.view.frame)
        self.view.addSubview(view)
        let topConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let botConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let rigthConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConst,botConst,leftConst,rigthConst])
        view.translatesAutoresizingMaskIntoConstraints = false // Make the view full-screen.
        
        let scene = AutoScene(size: self.view.frame.size, trains: [
            TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: 100),
            TrainNode(direction: .outBound, acceleration: 0, maximumSpeed: 100),
            TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: 100),
            TrainNode(direction: .outBound, acceleration: 0, maximumSpeed: 100),
            TrainNode(direction: .inBound, acceleration: 0, maximumSpeed: 100),
            TrainNode(direction: .outBound, acceleration: 0, maximumSpeed: 100)
            
            ], blockCount: 15)
        
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the view.
        scene.scaleMode = .aspectFill
        view.preferredFramesPerSecond = 30
        view.presentScene(scene)
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
