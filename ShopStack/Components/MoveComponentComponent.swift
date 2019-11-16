//
//  PlayerControllerComponent.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import GameplayKit
import SceneKit
 
class MoveComponent: GKComponent {
    // MARK: Properties
 
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var speed: Float = 0.05
    var speedThreshold: Float = 5
    var leftRotation = SCNVector4Make(0, -0.035, 0, 1)
    var rightRotation = SCNVector4Make(0, 0.035, 0, 1)
    
    func rotateDirectionRight() {
        geometryComponent?.geometryNode.physicsBody?.applyTorque(leftRotation, asImpulse: true)
    }
    
    func rotateDirectionLeft() {
        geometryComponent?.geometryNode.physicsBody?.applyTorque(rightRotation, asImpulse: true)
    }
    
    
    // MARK: Methods
    
    /// Tells this entity's geometry component to move forward constantly based on physics movement
    func moveForward() {
        geometryComponent?.geometryNode.physicsBody?.applyForce((geometryComponent?.geometryNode.presentation.worldFront)! * speed, asImpulse: true)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
       moveForward()
    }
}
