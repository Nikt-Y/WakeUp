//
//  BalanceNode.swift
//  WakeUp
//
//  Created by Nik Y on 24.08.2023.
//

import SpriteKit

class BalanceNode: SKNode {
    //MARK: - Properties
    private var bg = SKShapeNode()
    private var balanceLabel = SKLabelNode()
    private var slepsCoinsNode = SKSpriteNode()
    
    //MARK: - Settings
    private(set) var balance: Int = 0 {
        didSet {
            if balance > 9999 {
                balanceLabel.text = "rich"
            } else {
                balanceLabel.text = "\(balance)"
            }
        }
    }
    
    //MARK: - Initializes
    override init() {
        super.init()
        
        setupBG()
        setupBalanceLabel()
        setupSlepsCoinsNode()
        updateBalance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setups

extension BalanceNode {
    
    private func setupBG() {
        bg = SKShapeNode(rectOf: CGSize(width: 150, height: 44), cornerRadius: 5)
        bg.fillColor = .init(hex: 0x011687)
        bg.lineWidth = 4
        bg.strokeColor = .black
        bg.zPosition = 1.0
        addChild(bg)
    }
    
    private func setupBalanceLabel() {
        balanceLabel = SKLabelNode(fontNamed: "Hardpixel")
        balanceLabel.fontSize = 40
        balanceLabel.text = "\(balance)"
        balanceLabel.zPosition = 2.0
        balanceLabel.fontColor = .cyan
        balanceLabel.horizontalAlignmentMode = .right
        balanceLabel.position = CGPoint(x: bg.frame.size.width/2 - 38, y: -balanceLabel.frame.height/2)
        addChild(balanceLabel)
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
extension BalanceNode {
    
    func updateBalance() {
        self.balance = UserDefaults.standard.integer(forKey: balanceKey)
    }
    
    func redAnimation() {
        balanceLabel.removeAllActions()
        let changeToRed = SKAction.run {
            self.balanceLabel.fontColor = UIColor.red
            self.slepsCoinsNode.texture = SKTexture(imageNamed: "zzzR")
        }
        let changeToOriginalColor = SKAction.run {
            self.balanceLabel.fontColor = UIColor.cyan
            self.slepsCoinsNode.texture = SKTexture(imageNamed: "zzz")
        }
        let sequence = SKAction.sequence([changeToRed, .wait(forDuration: 0.4) ,changeToOriginalColor])
        balanceLabel.run(sequence)
    }
}

