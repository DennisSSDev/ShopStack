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
    
    // which menu view is the camera on right now
    var activeViewLocation = 1
    let cameraMoveToLocations = [
        SCNVector3(-19, 6.2, 38),
        SCNVector3(-1.4, 6.2, 38),
        SCNVector3(18.5, 6.5, 46)
    ]
    
    /// Keeps track of the time for use in the update method.
    var previousUpdateTime: TimeInterval = 0
    
    var globalCamera: SCNNode = SCNNode()
    
    var playerControlSystem: PlayerControlComponentSystem!
    
    var playerScoreSystem: PlayerScoreComponentSystem!
    
    var updateSystems = [
        GKComponentSystem(componentClass: CameraControlComponent.self),
        GKComponentSystem(componentClass: MoveComponent.self),
        GKComponentSystem(componentClass: TrayComponent.self),
    ]
    
    var pressedStart = false
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        guard let camera = scene.rootNode.childNode(withName: "camera", recursively: false) else {
            return
        }
        
        globalCamera = camera
        
        setUpEntities()
        setupUpdateSystems()
        
        self.playerControlSystem = PlayerControlComponentSystem(fromComponentIn: entities[0])
        self.playerScoreSystem = PlayerScoreComponentSystem(entities[0].component(ofType: PlayerScoreComponent.self)!)
        
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
        // Update the previous update time to keep future calculations accurate.
        previousUpdateTime = time
        
        // don't run the systems until the game started
        if !pressedStart {
             return
        }
        
        for sys in updateSystems {
            sys.update(deltaTime: timeSincePreviousUpdate)
        }
        playerControlSystem.update(deltaTime: timeSincePreviousUpdate)
        playerScoreSystem.update(deltaTime: timeSincePreviousUpdate)
    }
}
