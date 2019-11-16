//
//  PlayerScoreSystem.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/15/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit

class PlayerScoreComponentSystem: GKComponentSystem<PlayerScoreComponent> {
    
    var playerScoreComponent: PlayerScoreComponent!
    
    var storedNodes: [SCNNode] {
        return playerScoreComponent.storedNodes
    }
    
    var score: UInt32 {
        return playerScoreComponent.score
    }
    
    var weight: Float {
        return playerScoreComponent.weight
    }
    
    func scorePoints() {
       playerScoreComponent.scorePoints()
    }
    
    func tryDropNodes() {
        playerScoreComponent.attemptDrop()
    }
    
    func storeNode(_ node: SCNNode) {
        playerScoreComponent.storeNode(node)
    }
    
    init(_ component: PlayerScoreComponent) {
        playerScoreComponent = component
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        playerScoreComponent.update(deltaTime: seconds)
    }
}

