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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = game.scene
        
        // game class becomes the main driver
        scnView.delegate = game
        
        controlSystem = game.playerControlSystem
        
        // show statistics such as fps and timing information
        // scnView.showsStatistics = true
        
        // add a tap gesture recognizer
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        holdGesture.delaysTouchesBegan = false
        holdGesture.minimumPressDuration = 0
        scnView.addGestureRecognizer(holdGesture)
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
