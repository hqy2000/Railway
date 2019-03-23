//
//  LineNode.swift
//  test1
//
//  Created by hqy2000 on 2019/3/16.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SpriteKit

public class TrackNode: SKShapeNode {
    private let type: Type
    public let range: Int = 100
    
    init(type: Type) {
        self.type = type
        super.init()
        let pathToDraw = CGMutablePath()
        switch (type) {
        case .single:
            self.addSingleTrack(to: pathToDraw, direction: .inBound)
            self.addSingleTrack(to: pathToDraw, direction: .outBound)
        case .double:
            self.addDoubleTrack(to: pathToDraw, direction: .inBound)
            self.addDoubleTrack(to: pathToDraw, direction: .outBound)
        }
        self.path = pathToDraw
        self.lineWidth = 5.0
        self.strokeColor = SKColor.white
        
    }
    
    /**
     Get a path for a track.
     - Returns: The CGMutablePath of the track.
     */
    public func getPath(for direction: Direction) -> CGMutablePath {
        let path = CGMutablePath()
        switch type {
        case .single:
            self.addSingleTrack(to: path, direction: direction)
        case .double:
            self.addDoubleTrack(to: path, direction: direction)
        }
        return path
    }
    
    private func addSingleTrack(to path: CGMutablePath, direction: Direction) {
        path.move(to: CGPoint(x: -125, y: 15 * direction.rawValue))
        path.addLine(to: CGPoint(x: -80, y: 15 * direction.rawValue))
        path.addCurve(to: CGPoint(x: -60, y: 0), control1: CGPoint(x: -70, y: 15 * direction.rawValue), control2: CGPoint(x: -70, y: 0))
        path.addLine(to: CGPoint(x: 60, y: 0))
        path.addCurve(to: CGPoint(x: 80, y: 15 * direction.rawValue), control1: CGPoint(x: 70, y: 0), control2: CGPoint(x: 70, y: 15 * direction.rawValue))
        path.addLine(to: CGPoint(x: 125, y: 15 * direction.rawValue))
    }
    
    private func addDoubleTrack(to path: CGMutablePath, direction: Direction) {
        path.move(to: CGPoint(x: -120, y: 15 * direction.rawValue))
        path.addLine(to: CGPoint(x: 120, y: 15 * direction.rawValue))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawLine(magicNumber: Int = 1) {
        
    }
    
    public enum Direction: Int {
        case inBound = 1
        case outBound = -1
    }
    
    public enum `Type` {
        case single
        case double
    }
}
