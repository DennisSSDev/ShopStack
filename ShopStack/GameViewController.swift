//
//  GameViewController.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/10/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    let game = Game() // game handler & physics delegate
    var controlSystem: PlayerControlComponentSystem!
    var scnView: SCNView! // active scene
    
    var allGestures: [UIGestureRecognizer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve the active scene view
        scnView = (self.view as! SCNView)
        
        // set the gameplay scene to the active view
        scnView.scene = game.scene
        
        // game class becomes the main physics driver
        scnView.delegate = game
        
        // assign the control system
        controlSystem = game.playerControlSystem
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
    
        // enable swipe recognition
        addSwipe(view: scnView)
        
        scnView.audioListener = game.globalCamera
        let bckLoop = SCNAudioSource(fileNamed: "BraveWorld.wav")
        bckLoop?.loops = true
        bckLoop?.volume = 0.5
        bckLoop?.load()
        
        let musicPlayer = SCNAudioPlayer(source: bckLoop!)
        game.globalCamera.addAudioPlayer(musicPlayer)
        
        // enable tap recognition
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.addTarget(self, action: #selector(sceneViewTapped(sender:)))
        scnView.addGestureRecognizer(tapGesture)
        allGestures.append(tapGesture)
    }
    
    // MARK: - Helpers
    
    /// helper function for adding the swiping detection to the scene view
    func addSwipe(view: SCNView) {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            gesture.direction = direction
            allGestures.append(gesture)
            view.addGestureRecognizer(gesture)
        }
    }
    
    // MARK: Post Play Button Init
    
    /// Function call that happens once the play button is hit.
    /// Put all the last minute logic that needs to run before the player takes control of the cart
    func beginGame() {
        // add a tap gesture recognizer
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        holdGesture.minimumPressDuration = 0.1
        scnView.addGestureRecognizer(holdGesture)
        
        // remove the menu swipe actions
        for gesture in allGestures {
            scnView.removeGestureRecognizer(gesture)
        }
        
        // add a swipe up gesture
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(_:)))
        swipeUpGesture.direction = .up
        scnView.addGestureRecognizer(swipeUpGesture)
        game.globalCamera.removeAllAudioPlayers()
        
        let bckLoop = SCNAudioSource(fileNamed: "happy.mp3")
        bckLoop?.loops = true
        bckLoop?.volume = 0.38
        bckLoop?.load()
        
        let musicPlayer = SCNAudioPlayer(source: bckLoop!)
        game.globalCamera.addAudioPlayer(musicPlayer)
        
        guard let UI = game.scene.rootNode.childNode(withName: "UI", recursively: false) else {
            return
        }
        UI.isHidden = true
        // begin the game
        game.pressedStart = true
    }
    
    // MARK: - Gesture Handlers
    
    /// handler for turning the Cart left and right
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            controlSystem.stopTurning()
            return
        }
        if sender.state == UIGestureRecognizer.State.began {
            // enable rotation
            
            // retrieve the SCNView
            let scnView = self.view as! SCNView
            
            // check what nodes are tapped
            let p = sender.location(in: scnView)
            
            let width = scnView.frame.width
            if p.x > width / 2 {
                controlSystem.turnPlayerRight()
            } else {
                controlSystem.turnPlayerLeft()
            }
        }
    }
    
    /// handler for making the cart jump/hop
    @objc func handleSwipeUp(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            controlSystem.jump()
        }
    }
    
    /// handler for tapping the scene view. Mainly used to detect a button press on the play button
    @objc func sceneViewTapped(sender: UITapGestureRecognizer) {
        if game.pressedStart {
            return
        }
        
        let loc = sender.location(in: scnView)
        
        let hitResults = scnView.hitTest(loc, options: nil)
        if hitResults.count == 0 {
            return
        }
        let result = hitResults.first
        if let node = result?.node {
            if node.name == "PlayButton" || node.name == "button" {
                beginGame()
            }
        }
    }

    /// hanlder for swiping left and right. Mainly used for swiping through the beginning game menu
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if game.pressedStart {
            return
        }
        if sender.direction == .left {
            // swipe to the active right item
            if game.activeViewLocation < 2 {
                game.activeViewLocation += 1
                let action = SCNAction.move(to: game.cameraMoveToLocations[game.activeViewLocation], duration: 0.5)
                action.timingMode = .easeInEaseOut
                game.globalCamera.runAction(action)
            }
        } else if sender.direction == .right {
            // swipe to the active left item
            if game.activeViewLocation > 0 {
                game.activeViewLocation -= 1
                let action = SCNAction.move(to: game.cameraMoveToLocations[game.activeViewLocation], duration: 0.5)
                action.timingMode = .easeInEaseOut
                game.globalCamera.runAction(action)
            }
        }
    }
    
    // MARK: - Overrides
    
    /// hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// enable the views for the appropriate system
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

}
