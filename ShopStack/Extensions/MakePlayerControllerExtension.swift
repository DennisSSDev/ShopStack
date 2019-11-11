//
//  makePlayerController.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit

extension Game {
    private func nodeLoadFailure(targetName: String) {
        fatalError("Making box with name \(targetName) failed because the GameScene scene file contains no nodes with that name.")
    }
    
    func makePlayerController(boxName: String, cameraName:  String) -> GKEntity? {
        let player = GKEntity()
        
        guard let boxNode = scene.rootNode.childNode(withName: boxName, recursively: true) else {
            nodeLoadFailure(targetName: boxName)
            return nil
        }
        
        guard let cameraNode = scene.rootNode.childNode(withName: cameraName, recursively: true) else {
            nodeLoadFailure(targetName: cameraName)
            return nil
        }
        
        let geoComponent = GeometryComponent(geometryNode: boxNode)
        geoComponent.geometryNode.physicsBody?.contactTestBitMask = 2
        let playerControlComponent = PlayerControlComponent()
        let moveComponent = MoveComponent()
        let camControlComponent = CameraControlComponent(cameraNode: cameraNode, target: geoComponent)
        
        player.addComponent(geoComponent)
        player.addComponent(playerControlComponent)
        player.addComponent(moveComponent)
        player.addComponent(camControlComponent)
        
        return player
    }
}
