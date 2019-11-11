//
//  GeometryComponent.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit
 
// class to store geometry data of a node
class GeometryComponent: GKComponent {
    // MARK: Properties
    
    /// A reference to the box in the scene that the entity controls.
    let geometryNode: SCNNode
    
    // MARK: Initialization
    
    init(geometryNode: SCNNode) {
        self.geometryNode = geometryNode
        super.init()
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
