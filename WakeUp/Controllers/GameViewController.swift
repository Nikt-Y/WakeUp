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
        
//        UIFont.familyNames.forEach({
//            print($0)
//        })
        
        
        guard let view = self.view as? SKView else {
            return
        }
        
//        let scene = GameScene(size: CGSize(width: screenSize.width, height: screenSize.height), bedroomsCount: 6)
//        let scene = GameOverScene(size: screenSize, score: 0, bedroomsCount: 6)
        let scene = HomeScene(size: screenSize)
        scene.scaleMode = .aspectFill
        
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        view.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
