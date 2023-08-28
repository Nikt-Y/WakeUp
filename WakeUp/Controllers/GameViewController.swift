//
//  GameViewController.swift
//  WakeUp
//
//  Created by Nik Y on 23.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else {
            return
        }
        
        let scene = HomeScene(size: screenSize)
        scene.scaleMode = .aspectFill
        
        view.ignoresSiblingOrder = true
        view.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
