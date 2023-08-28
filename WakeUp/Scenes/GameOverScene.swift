//
//  GameOverScene.swift
//  WakeUp
//
//  Created by Nik Y on 22.08.2023.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    //MARK: - Properties
    private var bgNode: SKSpriteNode!
    private var afterGameNode: AfterGameNode!
    
    //MARK: - Settings
    private var score: Int!
    private(set) var bedroomsCount: Int = 0
    private var highscore: Int = 0
    private var balance: Int = 0
    
    //MARK: - Initializes
    init(size: CGSize, score: Int, bedroomsCount: Int) {
        super.init(size: size)
        self.score = score
        self.bedroomsCount = bedroomsCount
        self.highscore = UserDefaults.standard.integer(forKey: highscoreKey)
        self.balance = UserDefaults.standard.integer(forKey: balanceKey) + score
        UserDefaults.standard.set(balance, forKey: balanceKey)
        
        if self.score > self.highscore {
            highscore = score
            UserDefaults.standard.set(score, forKey: highscoreKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        BackgroundMusicManager.shared.setupBackgroundMusic(forScene: self, withFiles: ["burnedOut", "gameOver"])
        setupBGnode()
        setupAfterGameNode()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

//MARK: - Setups

extension GameOverScene {
    
    private func setupBGnode() {
        bgNode = SKSpriteNode(imageNamed: "boss")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        let aspectRatio = bgNode.size.width / bgNode.size.height
        bgNode.size = CGSize(width: screenSize.height * aspectRatio, height: screenSize.height)
        addChild(bgNode)
    }
    
    private func setupAfterGameNode() {
        afterGameNode = AfterGameNode(score: score, highscore: highscore, balance: balance, gameOverScene: self)
        afterGameNode.zPosition = 1.0
        let size = afterGameNode.calculateAccumulatedFrame().size
        
        afterGameNode.position = CGPoint(x: frame.midX, y: size.height/2 + 15)
        addChild(afterGameNode)
    }
}
