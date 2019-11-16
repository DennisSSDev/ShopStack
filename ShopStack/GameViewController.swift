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
    
    let game = Game()
    var controlSystem: PlayerControlComponentSystem!
    var scnView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        // retrieve the SCNView
        scnView = (self.view as! SCNView)
        
        // set the scene to the view
        scnView.scene = game.scene
        
        // game class becomes the main driver
        scnView.delegate = game
        
        controlSystem = game.playerControlSystem
        
        // show statistics such as fps and timing information
        // scnView.showsStatistics = true
        
        
        addSwipe(view: scnView)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.addTarget(self, action: #selector(sceneViewTapped(sender:)))
        
        scnView.addGestureRecognizer(tapGesture)
    }
    
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
    
    func addSwipe(view: SCNView) {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
    }
    
    func beginGame() {
        // add a tap gesture recognizer
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        holdGesture.delaysTouchesBegan = false
        holdGesture.minimumPressDuration = 0
        scnView.addGestureRecognizer(holdGesture)
        game.pressedStart = true
    }
    
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

    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if game.pressedStart {
            return
        }
        if sender.direction == .right {
            // swipe to the active right item
            if game.activeViewLocation < 2 {
                game.activeViewLocation += 1
                let action = SCNAction.move(to: game.cameraMoveToLocations[game.activeViewLocation], duration: 0.5)
                action.timingMode = .easeInEaseOut
                game.globalCamera.runAction(action)
            }
        } else if sender.direction == .left {
            // swipe to the active left item
            if game.activeViewLocation > 0 {
                game.activeViewLocation -= 1
                let action = SCNAction.move(to: game.cameraMoveToLocations[game.activeViewLocation], duration: 0.5)
                action.timingMode = .easeInEaseOut
                game.globalCamera.runAction(action)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
