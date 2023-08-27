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
    private var scrollNode: MySKScroll!
    private var alertNode: AlertNode!
    private var goods: [Good] = []
    
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
        setupScrollNode()
        setupGoods()
    }
        
    override func update(_ currentTime: TimeInterval) {
        
    }
}

//MARK: - Setups

extension ShopScene {
    
    private func setupBGnode() {
        let bgName = UserDefaults.standard.string(forKey: bgKey) ?? "background1"
        bgNode = SKSpriteNode(imageNamed: bgName)
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        let aspectRatio = bgNode.size.width / bgNode.size.height
        bgNode.size = CGSize(width: screenSize.height * aspectRatio, height: screenSize.height)
        addChild(bgNode)
    }
    
    private func setupBackBtn() {
        backBtn = MyButton(imageNamed: "backBtn", size: CGSize(width: 49, height: 49))
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
    
    func setupScrollNode() {
        let safeAreaInsets = view!.safeAreaInsets
        let size = backBtn.calculateAccumulatedFrame().size
        scrollNode = MySKScroll(size: CGSize(width: screenSize.width, height: screenSize.height - safeAreaInsets.top - size.height), offset: 15)
        scrollNode.position = CGPoint(x: frame.midX, y: frame.midY - size.height/2 - safeAreaInsets.top/2)
        addChild(scrollNode)
    }
    
    private func setupGoods() {
        let good1Status = getStatus(num: UserDefaults.standard.integer(forKey: keyGoodBG1))
        let good1 = Good(shopScene: self, goodName: keyGoodBG1, image: "good", cost: 0, status: good1Status)
        good1.action = { [self] in
            bgNode.texture = SKTexture(imageNamed: "background1")
            UserDefaults.standard.set("background1", forKey: bgKey)
        }
        
        let good2Status = getStatus(num: UserDefaults.standard.integer(forKey: keyGoodBG2))
        let good2 = Good(shopScene: self, goodName: keyGoodBG2, image: "background2", cost: 1, status: good2Status)
        good2.action = { [self] in
            bgNode.texture = SKTexture(imageNamed: "background2")
            UserDefaults.standard.set("background2", forKey: bgKey)
        }
        
        goods.append(good1)
        goods.append(good2)
        
        for good in goods {
            scrollNode.addScrollChild(good)
        }
    }
    
    private func getStatus(num: Int) -> GoodStatus {
        if num == 0 {
            return .choosen
        } else if num == 1 {
            return .bought
        } else {
            return .locked
        }
    }
    
    private func setupAlertNode(good: Good) {
        if alertNode != nil {
            alertNode.removeFromParent()
        }
        alertNode = AlertNode(
            message: "Do you really want to buy \"\(good.name ?? "this content")\"?",
            cancelAction: {
                self.alertNode.isHidden = true
            },
            acceptAction: {
                self.alertNode.isHidden = true
                
                self.balance -= good.cost
                UserDefaults.standard.set(self.balance, forKey: balanceKey)
                good.setNewStatus(newStatus: .bought)
            })
        alertNode.isHidden = false
        alertNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(alertNode)
    }
}

//MARK: - Actions

extension ShopScene {
    func redAnimationBalance() {
        balanceNode.redAnimation()
    }
    
    func updateBalance() {
        balanceNode.updateBalance()
    }
    
    func showAllert(good: Good) {
        setupAlertNode(good: good)
    }
    
    func chooseGood(choosen: Good) {
        for good in goods {
            if good.status != .locked {
                good.setNewStatus(newStatus: .bought)
            }
        }
        choosen.setNewStatus(newStatus: .choosen)
    }
}
