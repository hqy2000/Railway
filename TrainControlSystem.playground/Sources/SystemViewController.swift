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

public class SystemViewController: UIViewController {
    
    let train: TrainNode?
    let trains: [TrainNode]
    let blockCount: Int
    
    public init(train: TrainNode) {
        self.train = train
        self.trains = []
        self.blockCount = 0
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(trains: [TrainNode], blockCount: Int) {
        self.train = nil
        self.trains = trains
        self.blockCount = blockCount
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let view = SKView(frame: self.view.frame)
        self.view.addSubview(view)
        let topConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let botConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let rigthConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConst,botConst,leftConst,rigthConst])
        view.translatesAutoresizingMaskIntoConstraints = false // Make the view full-screen.
        
        if let train = self.train {
            let scene = StaffScene(size: CGSize(width: 300, height: 200), train: train)3
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the view.
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
        } else {
            let scene = AutoScene(size: CGSize(width: 300, height: 200), trains: self.trains, blockCount: self.blockCount)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the view.
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
        
        
        view.preferredFramesPerSecond = 30
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
    }

    override public var shouldAutorotate: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
}
