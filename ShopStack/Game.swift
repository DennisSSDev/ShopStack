//
//  Game.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit
 
class Game: NSObject, SCNSceneRendererDelegate {
    // MARK: Properties
    
    /// The scene that the game controls.
    let scene = SCNScene(named: "art.scnassets/main.scn")!
    
    /// Holds all the entities, so they won't be deallocated.
    var entities = [GKEntity]()
    
    /// Keeps track of the time for use in the update method.
    var previousUpdateTime: TimeInterval = 0
    
    var playerControlSystem: PlayerControlComponentSystem!
    
    var updateSystems = [
        GKComponentSystem(componentClass: CameraControlComponent.self),
        GKComponentSystem(componentClass: MoveComponent.self),
    ]
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        setUpEntities()
        setupUpdateSystems()
        
        self.playerControlSystem = PlayerControlComponentSystem(fromComponentIn: entities[0])
        
        scene.physicsWorld.contactDelegate = self
    }
    
    /**
        Sets up the entities for the scene.
    */
    func setUpEntities() {
        guard let playerEntity = makePlayerController(boxName: "box", cameraName: "camera") else {
            fatalError("Failed to create a player Entity")
        }
        entities.append(playerEntity)
    }
    
    func setupUpdateSystems() {
        for sys in updateSystems {
            for entity in entities {
                sys.addComponent(foundIn: entity)
            }
        }
    }
    
    /**
        Updates every frame, and keeps components in the particle component
        system up to date.
    */
    func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Calculate the time change since the previous update.
        let timeSincePreviousUpdate = time - previousUpdateTime
        for sys in updateSystems {
            sys.update(deltaTime: timeSincePreviousUpdate)
        }
        playerControlSystem.update(deltaTime: timeSincePreviousUpdate)
        // Update the previous update time to keep future calculations accurate.
        previousUpdateTime = time
    }
}
