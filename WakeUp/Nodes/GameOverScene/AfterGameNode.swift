//
//  AfterGameNode.swift
//  WakeUp
//
//  Created by Nik Y on 22.08.2023.
//

import SpriteKit

class AfterGameNode: SKNode {
    
    //MARK: - Properties
    private var node = SKShapeNode()
    private var gameOverLabel = SKLabelNode()
    private var scoreTextLabel = SKLabelNode()
    private var scoreLabel = SKLabelNode()
    private var highscoreTextLabel = SKLabelNode()
    private var highscoreLabel = SKLabelNode()
    private var balanceTextLabel = SKLabelNode()
    private var balanceLabel = SKLabelNode()
    private var slepsCoinsNode = SKSpriteNode()
    private var homeBtn = SKSpriteNode()
    private var playAgainBtn = SKSpriteNode()
    
    // MARK: - Settings
    private var score: Int = 0
    private var highscore: Int = 0
    private var balance: Int = 0
    private var gameOverScene: GameOverScene?
    
    private var isHome = false {
        didSet {
            updateBtn(node: homeBtn, event: isHome)
        }
    }
    
    private var isAgain = false {
        didSet {
            updateBtn(node: playAgainBtn, event: isAgain)
        }
    }
    
    //MARK: - Initializes
    override init() {
        super.init()
        isUserInteractionEnabled = true
    }
    
    init(score: Int, highscore: Int, balance: Int, gameOverScene: GameOverScene) {
        self.score = score
        self.highscore = highscore
        self.balance = balance
        self.gameOverScene = gameOverScene
        super.init()
        
        isUserInteractionEnabled = true
        
        setupNode()
        setupGameOverLabel()
        setupHomeBtn()
        setupPlayAgainBtn()
        setupScoreLabels()
        setupHighscoreLabels()
        setupBalanceLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        
        let node = atPoint(touch.location(in: self))
        
        if node.name == "home" && !isHome {
            isHome = true
        }
        
        if node.name == "again" && !isAgain {
            isAgain = true
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = homeBtn.parent {
            isHome = homeBtn.contains(touch.location(in: parent))
        }
        
        if let parent = playAgainBtn.parent {
            isAgain = playAgainBtn.contains(touch.location(in: parent))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isHome {
            isHome = false
            let scene = HomeScene(size: screenSize)
            scene.scaleMode = .aspectFill
            gameOverScene?.view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        }
        
        if isAgain {
            isAgain = false
            let scene = GameScene(size: screenSize, bedroomsCount: gameOverScene?.bedroomsCount ?? 1)
            scene.scaleMode = .aspectFill
            gameOverScene?.view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        }
    }
}

//MARK: - Setups

extension AfterGameNode {
    
    private func setupNode() {
        node = SKShapeNode(rectOf: CGSize(width: 353, height: 210), cornerRadius: 10)
        node.fillColor = UIColor(hex: 0x1E1E1E, alpha: 0.8)
        node.strokeColor = .black
        node.zPosition = 1.0
        addChild(node)
    }
    
    private func setupGameOverLabel() {
        gameOverLabel = SKLabelNode(fontNamed: "Hardpixel")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .white
        
        gameOverLabel.zPosition = 2.0
        gameOverLabel.position = CGPoint(x: 0, y: node.frame.height/2 - gameOverLabel.frame.height - 12)
        node.addChild(gameOverLabel)
    }
    
    private func setupHomeBtn() {
        homeBtn = SKSpriteNode(imageNamed: "homeBtn")
        homeBtn.name = "home"
        homeBtn.size = CGSize(width: 156, height: 42)
        homeBtn.zPosition = 2.0
        homeBtn.position = CGPoint(x: -node.frame.size.width/2 + homeBtn.size.width/2 + 9, y: -node.frame.height/2 + homeBtn.size.height/2 + 16)
        node.addChild(homeBtn)
    }
    
    private func setupPlayAgainBtn() {
        playAgainBtn = SKSpriteNode(imageNamed: "playAgainBtn")
        playAgainBtn.name = "again"
        playAgainBtn.size = CGSize(width: 156, height: 42)
        playAgainBtn.zPosition = 2.0
        playAgainBtn.position = CGPoint(x: node.frame.size.width/2 - playAgainBtn.size.width/2 - 9, y: -node.frame.height/2 + playAgainBtn.size.height/2 + 16)
        node.addChild(playAgainBtn)
    }
    
    private func setupScoreLabels() {
        scoreTextLabel = SKLabelNode(fontNamed: "Hardpixel")
        scoreTextLabel.text = "SCORE:"
        scoreTextLabel.fontSize = 30
        scoreTextLabel.fontColor = .white
        scoreTextLabel.horizontalAlignmentMode = .left
        scoreTextLabel.zPosition = 2.0
        scoreTextLabel.position = CGPoint(x: -node.frame.size.width/2 + 9, y: gameOverLabel.position.y - scoreTextLabel.frame.height - 9)
        node.addChild(scoreTextLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Hardpixel")
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.zPosition = 2.0
        scoreLabel.position = CGPoint(x: node.frame.size.width/2 - 9, y: scoreTextLabel.position.y)
        node.addChild(scoreLabel)
    }
    
    private func setupHighscoreLabels() {
        highscoreTextLabel = SKLabelNode(fontNamed: "Hardpixel")
        highscoreTextLabel.text = "HIGHSCORE:"
        highscoreTextLabel.fontSize = 30
        highscoreTextLabel.fontColor = .white
        highscoreTextLabel.horizontalAlignmentMode = .left
        highscoreTextLabel.zPosition = 2.0
        highscoreTextLabel.position = CGPoint(x: -node.frame.size.width/2 + 9, y: scoreTextLabel.position.y - highscoreTextLabel.frame.height - 9)
        node.addChild(highscoreTextLabel)
        
        highscoreLabel = SKLabelNode(fontNamed: "Hardpixel")
        highscoreLabel.text = "\(highscore)"
        highscoreLabel.fontSize = 30
        highscoreLabel.fontColor = .white
        highscoreLabel.horizontalAlignmentMode = .right
        highscoreLabel.zPosition = 2.0
        highscoreLabel.position = CGPoint(x: node.frame.size.width/2 - 9, y: highscoreTextLabel.position.y)
        node.addChild(highscoreLabel)
    }
    
    private func setupBalanceLabels() {
        balanceTextLabel = SKLabelNode(fontNamed: "Hardpixel")
        balanceTextLabel.text = "NEW BALANCE:"
        balanceTextLabel.fontSize = 30
        balanceTextLabel.fontColor = .white
        balanceTextLabel.horizontalAlignmentMode = .left
        balanceTextLabel.zPosition = 2.0
        balanceTextLabel.position = CGPoint(x: -node.frame.size.width/2 + 9, y: highscoreTextLabel.position.y - balanceTextLabel.frame.height - 9)
        node.addChild(balanceTextLabel)
        
        slepsCoinsNode = SKSpriteNode(imageNamed: "zzzW")
        slepsCoinsNode.size = CGSize(width: 18, height: 18)
        slepsCoinsNode.anchorPoint = CGPoint(x: 1, y: 0)
        slepsCoinsNode.zPosition = 2.0
        slepsCoinsNode.position = CGPoint(x: node.frame.size.width/2 - 9, y: balanceTextLabel.position.y)
        node.addChild(slepsCoinsNode)
        
        balanceLabel = SKLabelNode(fontNamed: "Hardpixel")
        balanceLabel.text = "\(balance)"
        balanceLabel.fontSize = 30
        balanceLabel.fontColor = .white
        balanceLabel.horizontalAlignmentMode = .right
        balanceLabel.zPosition = 2.0
        balanceLabel.position = CGPoint(x: node.frame.size.width/2 - slepsCoinsNode.size.width - 11, y: balanceTextLabel.position.y)
        node.addChild(balanceLabel)
    }
}

//MARK: - Actions

extension AfterGameNode {
    
    private func updateBtn(node: SKNode, event: Bool) {
        var alpha: CGFloat = 1.0
        if event {
            alpha = 0.5
        }
        
        node.run(.fadeAlpha(to: alpha, duration: 0.1))
    }
}
