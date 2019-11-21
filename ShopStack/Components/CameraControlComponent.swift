//
//  CameraControlComponent.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import GameplayKit
import SceneKit
 
class CameraControlComponent: GKComponent {
    // MARK: Properties
 
    
    let cameraNode: SCNNode
    let targetNode: SCNNode
    
    // MARK: Initialization
    
    init(cameraNode: SCNNode, target: GeometryComponent) {
        self.cameraNode = cameraNode
        self.targetNode = target.geometryNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        // follow target
        let targetPos = SCNVector3(targetNode.presentation.position.x, targetNode.presentation.position.y + 19, targetNode.presentation.position.z-17)
        let cameraPosition = cameraNode.position
        
        let camDamping: Float = 0.3
        
        let newCamX = cameraPosition.x * (1-camDamping) + targetPos.x * camDamping
        let newCamY = cameraPosition.y * (1-camDamping) + targetPos.y * camDamping
        let newCamZ = cameraPosition.z * (1-camDamping) + targetPos.z * camDamping
        
        cameraNode.position = SCNVector3Make(newCamX, newCamY, newCamZ)
        cameraNode.look(at: targetNode.presentation.worldPosition)
    }
 
    // MARK: Methods
}
