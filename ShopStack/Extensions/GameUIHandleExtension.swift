//
//  GameUIHandleExtension.swift
//  ShopStack
//
//  Created by Dennis Slavinsky on 11/25/19.
//  Copyright © 2019 Kinda Cool Stuff. All rights reserved.
//

import SceneKit
import GameplayKit

/// extension to handle ui updates on a separate thread
extension Game {
    
    func updateWeightUI() {
        self.weight.string = "Weight: \( (1000 * self.playerScoreSystem.weight * 10).rounded() / 1000 ) kg"
    }
    
    func updateScoreUI() {
        self.score.string = "Score: \(self.playerScoreSystem.score) pp"
    }
    
    /// initialize the UI thread and run the updates
    func beginUIUpdate() {
        // timer
        let action = SCNAction.repeatForever(SCNAction.sequence([
            SCNAction.run({_ in
                self.updateWeightUI()
                self.updateScoreUI()
            }),
            SCNAction.wait(duration: 0.2)
        ]))
        scene.rootNode.runAction(action)
    }
}
