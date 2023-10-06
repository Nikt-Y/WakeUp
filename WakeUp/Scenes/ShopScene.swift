//
//  ShopScene.swift
//  WakeUp
//
//  Created by Nik Y on 26.08.2023.
//

import SpriteKit

class ShopScene: SKScene {
    //MARK: - Properties
    private var bgNode = SKSpriteNode()
    private var backBtn = MyButton()
    private var balanceNode = BalanceNode()
    private var scrollNode = MySKScroll()
    private var alertNode = AlertNode()
    private var goods: [Good] = []
    
    //MARK: - Settings
    private var balance: Int = 0
    
    //MARK: - Initializes
    override init(size: CGSize) {
        super.init(size: size)
        
        self.balance = UserDefaults.standard.integer(forKey: balanceKey)
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
        backBtn.zPosition = 5.0
        let safeAreaInsets = view!.safeAreaInsets
        let size = backBtn.calculateAccumulatedFrame().size
        backBtn.position = CGPoint(x: safeAreaInsets.left + size.width/2, y: -safeAreaInsets.top - size.height/2 + frame.maxY)
        addChild(backBtn)
    }
    
    private func setupBalanceNode() {
        balanceNode = BalanceNode()
        balanceNode.zPosition = 1.0
        let safeAreaInsets = view!.safeAreaInsets
        let size = balanceNode.calculateAccumulatedFrame().size
        balanceNode.position = CGPoint(x: frame.maxX - size.width/2 - safeAreaInsets.right, y: -safeAreaInsets.top - size.height/2 + frame.maxY)
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
        let good1Status = getStatus(num: UserDefaults.standard.integer(forKey: keyBgSunrise1))
        let good1 = Good(shopScene: self, type: .background, goodName: keyBgSunrise1, image: "sunrise1Little", cost: 1, status: good1Status)
        good1.action = { [self] in
            bgNode.texture = SKTexture(imageNamed: "sunrise1")
            UserDefaults.standard.set("sunrise1", forKey: bgKey)
        }
        
        let good2Status = getStatus(num: UserDefaults.standard.integer(forKey: keyBgSunrise2))
        let good2 = Good(shopScene: self, type: .background, goodName: keyBgSunrise2, image: "sunrise2Little", cost: 20, status: good2Status)
        good2.action = { [self] in
            bgNode.texture = SKTexture(imageNamed: "sunrise2")
            UserDefaults.standard.set("sunrise2", forKey: bgKey)
        }
        
        let good3Status = getStatus(num: UserDefaults.standard.integer(forKey: keyBgFutureCity))
        let good3 = Good(shopScene: self, type: .background, goodName: keyBgFutureCity, image: "futureCityLittle", cost: 40, status: good3Status)
        good3.action = { [self] in
            bgNode.texture = SKTexture(imageNamed: "futureCity")
            UserDefaults.standard.set("futureCity", forKey: bgKey)
        }

        let good4Status = getStatus(num: UserDefaults.standard.integer(forKey: keyBgCyberCity))
        let good4 = Good(shopScene: self, type: .background, goodName: keyBgCyberCity, image: "cyberCityLittle", cost: 60, status: good4Status)
        good4.action = { [self] in
            bgNode.texture = SKTexture(imageNamed: "cyberCity")
            UserDefaults.standard.set("cyberCity", forKey: bgKey)
        }

        let good5Status = getStatus(num: UserDefaults.standard.integer(forKey: keyBgNightCity))
        let good5 = Good(shopScene: self, type: .background, goodName: keyBgNightCity, image: "nightCityLittle", cost: 80, status: good5Status)
        good5.action = { [self] in
            bgNode.texture = SKTexture(imageNamed: "nightCity")
            UserDefaults.standard.set("nightCity", forKey: bgKey)
        }

        let good6Status = getStatus(num: UserDefaults.standard.integer(forKey: keyStyleDefault))
        let good6 = Good(shopScene: self, type: .style, goodName: keyStyleDefault, image: "styleDefault", cost: 1, status: good6Status)
        good6.action = {
            UserDefaults.standard.set("styleDefault", forKey: styleKey)
        }
        
        let good7Status = getStatus(num: UserDefaults.standard.integer(forKey: keyStyleNight))
        let good7 = Good(shopScene: self, type: .style, goodName: keyStyleNight, image: "styleNight", cost: 20, status: good7Status)
        good7.action = {
            UserDefaults.standard.set("styleNight", forKey: styleKey)
        }

        let good8Status = getStatus(num: UserDefaults.standard.integer(forKey: keyStyleEmpty))
        let good8 = Good(shopScene: self, type: .style, goodName: keyStyleEmpty, image: "styleEmpty", cost: 40, status: good8Status)
        good8.action = {
            UserDefaults.standard.set("styleEmpty", forKey: styleKey)
        }

        let good9Status = getStatus(num: UserDefaults.standard.integer(forKey: keyStyleSunrise))
        let good9 = Good(shopScene: self, type: .style, goodName: keyStyleSunrise, image: "styleSunrise", cost: 60, status: good9Status)
        good9.action = {
            UserDefaults.standard.set("styleSunrise", forKey: styleKey)
        }

        let good10Status = getStatus(num: UserDefaults.standard.integer(forKey: keyStyleRandom))
        let good10 = Good(shopScene: self, type: .style, goodName: keyStyleRandom, image: "styleRandom", cost: 80, status: good10Status)
        good10.action = {
            UserDefaults.standard.set("styleRandom", forKey: styleKey)
        }

        goods.append(contentsOf: [good1, good2, good3, good4, good5, good6, good7, good8, good9, good10])
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
                self.balanceNode.updateBalance()
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
            if good.status != .locked, good.type == choosen.type {
                good.setNewStatus(newStatus: .bought)
            }
        }
        choosen.setNewStatus(newStatus: .choosen)
    }
}
