//
//  TrayComponent.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/15/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit
 
// class to store all 4 sides of the tray for collision purposes
class TrayComponent: GKComponent {
    // MARK: Properties
    
    /// A reference to the box in the scene that the entity controls.
    var collisionNodes: [SCNNode]
    
    var geoNodes: [SCNNode]
    // MARK: Initialization
    
    init(geometryNodes: [SCNNode], parent: SCNNode) {
        collisionNodes = geometryNodes
        geoNodes = []
        geoNodes.append(parent.childNode(withName: "left", recursively: true)!)
        geoNodes.append(parent.childNode(withName: "right", recursively: true)!)
        geoNodes.append(parent.childNode(withName: "front", recursively: true)!)
        geoNodes.append(parent.childNode(withName: "back", recursively: true)!)
        super.init()
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        var iterator = 0
        for colNode in collisionNodes {
            colNode.worldPosition = geoNodes[iterator].presentation.worldPosition
            colNode.worldOrientation = geoNodes[iterator].presentation.worldOrientation
            iterator += 1
        }
    }
    
}
