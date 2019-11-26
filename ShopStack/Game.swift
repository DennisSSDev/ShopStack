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
    
    /// on screen values
    var timer: SCNText = SCNText()
    var timerNode: SCNNode = SCNNode()
    var weight: SCNText = SCNText()
    var weightNode: SCNNode = SCNNode()
    var score: SCNText = SCNText()
    var scoreNode: SCNNode = SCNNode()
    
    var gameOverScreen: SCNNode = SCNNode()
    
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
        
        setupGlobals()
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
    
    func setupGlobals() {
        guard let camera = scene.rootNode.childNode(withName: "camera", recursively: false) else {
            return
        }
        globalCamera = camera

        guard let timer = scene.rootNode.childNode(withName: "Timer", recursively: true) else {
            return
        }
        timerNode = timer
        timerNode.isHidden = true
        self.timer = timer.geometry as! SCNText
        
        guard let weight = scene.rootNode.childNode(withName: "Weight", recursively: true) else {
            return
        }
        weightNode = weight
        weightNode.isHidden = true
        self.weight = weight.geometry as! SCNText
        
        guard let score = scene.rootNode.childNode(withName: "Score", recursively: true) else {
            return
        }
        scoreNode = score
        scoreNode.isHidden = true
        self.score = score.geometry as! SCNText
        
        guard let gameOver = scene.rootNode.childNode(withName: "gameover", recursively: true) else {
            return
        }
        gameOverScreen = gameOver
        gameOverScreen.isHidden = true
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
