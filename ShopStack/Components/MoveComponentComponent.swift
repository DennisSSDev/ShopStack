//
//  PlayerControllerComponent.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import GameplayKit
import SceneKit
 
/// component for allowing an entity to move
class MoveComponent: GKComponent {
    // MARK: Properties
 
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var speed: Float = 3.5
    var speedThreshold: Float = 5
    var leftRotation = SCNVector4Make(0, -0.045, 0, 1)
    var rightRotation = SCNVector4Make(0, 0.045, 0, 1)
    let upward = SCNVector3(0, 1, 0)
    let jumpStrength: Float = 3
    
    func rotateDirectionRight() {
        geometryComponent?.geometryNode.physicsBody?.applyTorque(leftRotation, asImpulse: true)
    }
    
    func rotateDirectionLeft() {
        geometryComponent?.geometryNode.physicsBody?.applyTorque(rightRotation, asImpulse: true)
    }
    
    func jump() {
        geometryComponent?.geometryNode.physicsBody?.applyForce(upward * jumpStrength, asImpulse: true)
    }
    
    
    // MARK: Methods
    
    /// Tells this entity's geometry component to move forward constantly based on physics movement
    func moveForward(deltaTime seconds: TimeInterval) {
        geometryComponent?.geometryNode.physicsBody?.applyForce((geometryComponent?.geometryNode.presentation.worldFront)! * speed * Float(seconds), asImpulse: true)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
       moveForward(deltaTime: seconds)
        if let yComponent = geometryComponent?.geometryNode.presentation.worldUp.y {
           if let yPos = geometryComponent?.geometryNode.presentation.worldPosition.y {
            if yComponent < Float(0.0) && yPos < Float(0.5) {
                // you flipped over reset player
                geometryComponent?.geometryNode.physicsBody?.resetTransform()
            }
            }
        }
    }
}
