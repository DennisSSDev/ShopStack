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
        
        if contact.nodeA.categoryBitMask == 1 {
            other = contact.nodeB
            player = contact.nodeA
        } else {
            other = contact.nodeA
            player = contact.nodeB
        }
        
        if other.categoryBitMask == 2 {
            let bounce = contact.contactNormal.normalized() * -1.25
            player.physicsBody?.applyForce(bounce, asImpulse: true)
        }
    }
}
