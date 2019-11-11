//
//  PayerControlComponent.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import GameplayKit
import SceneKit
 
class PlayerControlComponent: GKComponent {
    // MARK: Properties
 
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var moveComponent: MoveComponent? {
        return entity?.component(ofType: MoveComponent.self)
    }
    
    private var bTurnLeft = false
    private var bTurnRight = false
 
    // MARK: Methods
    
    /// Tells this entity's geometry component to move forward constantly
    private func turnLeft() {
        moveComponent?.rotateDirectionLeft()
    }
    
    private func turnRight() {        
        moveComponent?.rotateDirectionRight()
    }
    
    func enableTurnLeft() {
        bTurnRight = false
        bTurnLeft = true
    }
    
    func enableTurnRight() {
        bTurnLeft = false
        bTurnRight = true
    }
    
    func stopTurning() {
        bTurnLeft = false;
        bTurnRight = false;
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if(bTurnLeft) {
            turnLeft()
        } else if(bTurnRight) {
            turnRight()
        }
    }
}
