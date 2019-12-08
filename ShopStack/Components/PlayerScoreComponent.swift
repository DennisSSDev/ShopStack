//
//  PlayerScoreComponent.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/15/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit
 
/// component to store the carts data such as weight, score, items in cart and apply manipulations on them
class PlayerScoreComponent: GKComponent {
    // MARK: Properties
    
    /// A reference to the box in the scene that the entity controls.
    
    // MARK: Initialization
    
    var score: UInt32 = 0
    var storedNodes: [SCNNode] = []
    
    let smallMass:CGFloat = 0.5
    let mediumMass:CGFloat = 1.0
    
    var maxDistance: Float = 5.0
    
    let dropForce = SCNVector3(0, 0.03, 0)
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var weight: Float {
        var weightSum: Float = 0.0
        for node in storedNodes {
            weightSum += Float(node.physicsBody?.mass ?? 0.0)
        }
        return weightSum
    }
    
    func scorePoints() {
        var result: UInt32 = 0
        for node in storedNodes {
            let mass = node.physicsBody?.mass ?? CGFloat(0.0)
            if mass < smallMass {
                result += 1
            } else if mass < mediumMass {
                result += 2
            } else {
                result += 3
            }
        }
        // todo: return the storedNodes to the market
        for node in storedNodes {
            node.worldPosition = SCNVector3(Int.random(in: -35...24), 10, Int.random(in: -60 ... -42))
            node.physicsBody?.contactTestBitMask = 1
        }
        storedNodes = []
        score += result
    }
    
    func storeNode(_ node: SCNNode) {
        storedNodes.append(node)
    }
    
    func attemptDrop() {
        for node in storedNodes {
            node.physicsBody?.applyForce(dropForce, asImpulse: true)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        var validNodes: [SCNNode] = []
        let geoNode = geometryComponent?.geometryNode
        if let cartNode = geoNode {
            for node in storedNodes {
                let distance = cartNode.presentation.worldPosition.distanceSqrd(vector: node.presentation.worldPosition)
                if distance < maxDistance {
                    validNodes.append(node)
                } else {
                    // cause the node to become attachable again
                    node.physicsBody?.contactTestBitMask = 1
                }
            }
        }
        storedNodes = validNodes
    }
}
