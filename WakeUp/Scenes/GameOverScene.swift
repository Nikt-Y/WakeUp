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
    private var bgNode = SKSpriteNode()
    private var afterGameNode = AfterGameNode()
    
    //MARK: - Settings
    private var score: Int = 0
    private(set) var bedroomsCount: Int = 0
    private var highscore: Int = 0
    private var balance: Int = 0
    private var wasStopped: Bool = false
    
    //MARK: - Initializes
    init(size: CGSize, score: Int, bedroomsCount: Int, wasStopped: Bool = false) {
        self.score = score
        self.bedroomsCount = bedroomsCount
        self.wasStopped = wasStopped
        self.highscore = UserDefaults.standard.integer(forKey: highscoreKey)
        self.balance = UserDefaults.standard.integer(forKey: balanceKey) + score
        super.init(size: size)
        
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
        if wasStopped {
            BackgroundMusicManager.shared.setupBackgroundMusic(forScene: self, withFiles: ["startBackgroundMusic"], repeatForever: true)
        } else {
            BackgroundMusicManager.shared.setupBackgroundMusic(forScene: self, withFiles: ["burnedOut", "gameOver"])
        }
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
        if wasStopped {
            let bgName = UserDefaults.standard.string(forKey: bgKey) ?? "background1"
            bgNode = SKSpriteNode(imageNamed: bgName)
        } else {
            bgNode = SKSpriteNode(imageNamed: "boss")
        }
        
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
        
        if wasStopped {
            afterGameNode.position = CGPoint(x: frame.midX, y: size.height/2 + 80)
        } else {
            afterGameNode.position = CGPoint(x: frame.midX, y: size.height/2 + 15)
        }
        addChild(afterGameNode)
    }
}
