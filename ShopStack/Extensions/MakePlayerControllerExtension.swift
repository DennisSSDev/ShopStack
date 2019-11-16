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
        
        guard let leftPlayerNode = scene.rootNode.childNode(withName: "c_left", recursively: true) else {
            nodeLoadFailure(targetName: "c_left")
            return nil
        }
        
        guard let rightPlayerNode = scene.rootNode.childNode(withName: "c_right", recursively: true) else {
            nodeLoadFailure(targetName: "c_right")
            return nil
        }
        guard let frontPlayerNode = scene.rootNode.childNode(withName: "c_front", recursively: true) else {
            nodeLoadFailure(targetName: "c_front")
            return nil
        }
        guard let backPlayerNode = scene.rootNode.childNode(withName: "c_back", recursively: true) else {
            nodeLoadFailure(targetName: "c_back")
            return nil
        }
        
        // the model of the cart
        let geoComponent = GeometryComponent(geometryNode: boxNode)
        geoComponent.geometryNode.physicsBody?.contactTestBitMask = 2
        // Controller component
        let playerControlComponent = PlayerControlComponent()
        // the physics solver
        let moveComponent = MoveComponent()
        // camera movement solver
        let camControlComponent = CameraControlComponent(cameraNode: cameraNode, target: geoComponent)
        // inner vox collision solver
        let trayComponent = TrayComponent(geometryNodes: [leftPlayerNode, rightPlayerNode, frontPlayerNode, backPlayerNode], parent: geoComponent.geometryNode)
        // scoring solver
        let scoreComponent = PlayerScoreComponent()
        
        player.addComponent(geoComponent)
        player.addComponent(playerControlComponent)
        player.addComponent(moveComponent)
        player.addComponent(camControlComponent)
        player.addComponent(trayComponent)
        player.addComponent(scoreComponent)
        
        return player
    }
}
