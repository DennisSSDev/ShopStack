//
//  GamePhysicsHandleExtension.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/11/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import Foundation
import SceneKit

extension Game: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var player: SCNNode!
        var other: SCNNode!
        // detect which one is the player
        if contact.nodeA.categoryBitMask == 1 {
            other = contact.nodeB
            player = contact.nodeA
        } else {
            other = contact.nodeA
            player = contact.nodeB
        }
        // hit a bouncing wall
        if other.categoryBitMask == 2 {
            let bounce = contact.contactNormal.normalized() * -750.0 * Float(world.timeStep)
            player.physicsBody?.applyForce(bounce, asImpulse: false)
            // since the player hit a bounce wall -> attempt to drop the contents
            self.playerScoreSystem.tryDropNodes()
            return
        }
        // hit a pick up item
        if other.categoryBitMask == 8 {
            other.physicsBody?.angularVelocity = SCNVector4Zero
            other.physicsBody?.contactTestBitMask = 0
            other.physicsBody?.isAffectedByGravity = true
            other.worldPosition = player.presentation.worldPosition + SCNVector3(0, 1.2, 0)
            other.rotation = player.presentation.rotation
            
            self.playerScoreSystem.storeNode(other)
            return
        }
    }
}
