//
//  ScoreNode.swift
//  WakeUp
//
//  Created by Nik Y on 22.08.2023.
//

import SpriteKit

class ScoreNode: SKNode {
    //MARK: - Properties
    private var bg = SKShapeNode()
    private var scoreLabel = SKLabelNode()
    private var slepsCoinsNode = SKSpriteNode()
    
    //MARK: - Settings
    private(set) var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    //MARK: - Initializes
    init(_ score: Int = 0) {
        super.init()
        
        self.score = score
        setupBG()
        setupScoreLabel()
        setupSlepsCoinsNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setups

extension ScoreNode {
    
    private func setupBG() {
        bg = SKShapeNode(rectOf: CGSize(width: 118, height: 48), cornerRadius: 5)
        bg.fillColor = .init(hex: 0x011687)
        bg.lineWidth = 4
        bg.strokeColor = .black
        bg.zPosition = 1.0
        addChild(bg)
    }
    
    private func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Hardpixel")
        scoreLabel.fontSize = 40
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 2.0
        scoreLabel.fontColor = .cyan
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: bg.frame.size.width/2 - 38, y: -scoreLabel.frame.height/2)
        addChild(scoreLabel)
    }
    
    private func setupSlepsCoinsNode() {
        slepsCoinsNode = SKSpriteNode(imageNamed: "zzz")
        slepsCoinsNode.size = CGSize(width: 21, height: 21)
        slepsCoinsNode.anchorPoint = CGPoint(x: 1, y: 0)
        slepsCoinsNode.zPosition = 2.0
        slepsCoinsNode.position = CGPoint(x: bg.frame.width/2 - 9, y: -bg.frame.height/2 + 9)
        addChild(slepsCoinsNode)
    }
}


//MARK: - Actions

extension ScoreNode {
    
    func addScore(by num: Int) {
        score += num

        let changeToGreen = SKAction.run {
            self.scoreLabel.fontColor = UIColor.green
            self.slepsCoinsNode.texture = .init(imageNamed: "zzzG")
        }
        let changeToOriginalColor = SKAction.run {
            self.scoreLabel.fontColor = UIColor.cyan
            self.slepsCoinsNode.texture = SKTexture(imageNamed: "zzz")
        }
        let sequence = SKAction.sequence([changeToGreen, .wait(forDuration: 0.4), changeToOriginalColor])
        scoreLabel.run(sequence)
    }

    func subtractScore(by num: Int) {
        if score - num >= 0 {
            score -= num
        } else {
            score = 0
        }
        
        let changeToRed = SKAction.run {
            self.scoreLabel.fontColor = UIColor.red
            self.slepsCoinsNode.texture = SKTexture(imageNamed: "zzzR")
        }
        let changeToOriginalColor = SKAction.run {
            self.scoreLabel.fontColor = UIColor.cyan
            self.slepsCoinsNode.texture = SKTexture(imageNamed: "zzz")
        }
        let sequence = SKAction.sequence([changeToRed, .wait(forDuration: 0.4) ,changeToOriginalColor])
        scoreLabel.run(sequence)
    }
}
