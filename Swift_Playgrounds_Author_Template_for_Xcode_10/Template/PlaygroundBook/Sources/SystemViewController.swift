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
        view.allowsTransparency = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        self.view.addSubview(view)
        self.constrain(view)
        
        let scene = self.getScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the view.
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        scene.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)

        view.preferredFramesPerSecond = 30
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    
    
    private func constrain(_ view: UIView) {
        let topConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let botConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let rigthConst = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConst,botConst,leftConst,rigthConst])
        view.translatesAutoresizingMaskIntoConstraints = false // Make the view full-screen.
    }
    /**
     Get the correct scene.
     */
    private func getScene() -> AbstractScene {
        let size = CGSize(width: 400, height: 600)
        if let train = self.train {
            return StaffScene(size: size, train: train)
        } else {
            return AutoScene(size: size, trains: self.trains, blockCount: self.blockCount)
        }
    }
}
