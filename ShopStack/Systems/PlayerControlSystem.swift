//
//  PlayerControlSystem.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit

class PlayerControlComponentSystem: GKComponentSystem<PlayerControlComponent> {
    
    var playerControlComponent: PlayerControlComponent
    
    init(fromComponentIn entity: GKEntity) {
        let component = entity.component(ofType: PlayerControlComponent.self)
        
        if let pcComp = component {
            playerControlComponent = pcComp
        } else {
            fatalError("couldn't assign the corrent player control component")
        }
        super.init()
    }
    
    func turnPlayerRight() {
        playerControlComponent.enableTurnRight()
    }
    
    func turnPlayerLeft() {
        playerControlComponent.enableTurnLeft()
    }
    
    func stopTurning() {
        playerControlComponent.stopTurning()
    }
    
    func jump() {
        playerControlComponent.jump();
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        playerControlComponent.update(deltaTime: seconds)
    }
}
