//
//  ShopScene.swift
//  WakeUp
//
//  Created by Nik Y on 26.08.2023.
//

import SpriteKit

class ShopScene: SKScene {
    //MARK: - Properties
    private var bgNode: SKSpriteNode!
    private var backBtn: MyButton!
    private var balanceNode: BalanceNode!
    private var goods: [MyButton]!
    
    //MARK: - Settings
    private var balance: Int = 0
    
    //MARK: - Initializes
    override init(size: CGSize) {
        super.init(size: size)
        
        self.balance = UserDefaults.standard.integer(forKey: highscoreKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        setupBGnode()
        setupBackBtn()
        setupBalanceNode()
        setupGoods()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

//MARK: - Setups

extension ShopScene {
    
    private func setupBGnode() {
        bgNode = SKSpriteNode(imageNamed: "background1")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        let aspectRatio = bgNode.size.width / bgNode.size.height
        bgNode.size = CGSize(width: screenSize.height * aspectRatio, height: screenSize.height)
        addChild(bgNode)
    }
    
    private func setupBackBtn() {
        backBtn = MyButton(imageNamed: "backBtn", size: CGSize(width: 47, height: 47))
        backBtn.action = {
            let scene = HomeScene(size: screenSize)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        }
        backBtn.zPosition = 1.0
        let safeAreaInsets = view!.safeAreaInsets;
        let size = backBtn.calculateAccumulatedFrame().size
        backBtn.position = CGPoint(x: size.width/2, y: -safeAreaInsets.top - size.height/2 + frame.maxY)
        addChild(backBtn)
    }
    
    private func setupBalanceNode() {
        balanceNode = BalanceNode()
        balanceNode.zPosition = 1.0
        let safeAreaInsets = view!.safeAreaInsets;
        let size = balanceNode.calculateAccumulatedFrame().size
        balanceNode.position = CGPoint(x: frame.maxX - size.width/2, y: -safeAreaInsets.top - size.height/2 + frame.maxY)
        addChild(balanceNode)
    }
    
    private func setupGoods() {
        for i in 0...1 {
            let good = MyButton(imageNamed: "good\(i)", size: CGSize(width: 172, height: 376))
            good.action = {
                self.buyGood(i)
            }
            good.zPosition = 1.0
            goods.append(good)
        }
    }
}

//MARK: - Actions

extension ShopScene {
    
    private func buyGood(_ num: Int) {
        
    }
}
