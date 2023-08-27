//
//  Good.swift
//  WakeUp
//
//  Created by Nik Y on 27.08.2023.
//

import SpriteKit

class Good: SKNode {
    //MARK: - Properties
    var action: (() -> ())?

    private var bg: SKShapeNode!
    private var goodImage: SKSpriteNode!
    private var goodNameLabel: SKLabelNode!
    private var costLabel: SKLabelNode!
    private(set) var cost: Int = 0
    private(set) var status: GoodStatus = .choosen
    private var shopScene: ShopScene!
    
    private var isInside = false {
        didSet {
            updateBtn()
        }
    }
    
    // MARK: - Initializers
    init(shopScene: ShopScene, goodName: String, image: String, cost: Int, status: GoodStatus) {
        super.init()
        self.shopScene = shopScene
        self.status = status
        self.name = goodName
        
        setupBg()
        setupImage(image: image)
        setupNameLabel(goodName: goodName)
        setupCostLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var touchMoved = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isInside = true
        touchMoved = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchMoved = true
        isInside = false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isInside && !touchMoved {
            isInside = false
            if let act = action {
                onSelect()
            }
        }
        isInside = false
        touchMoved = false
    }
}

//MARK: - Setups

extension Good {

    private func setupBg() {
        bg = SKShapeNode(rectOf: CGSize(width: 172, height: 376), cornerRadius: 10)
        bg.fillColor = .black
        bg.strokeColor = status.color
        addChild(bg)
    }
    
    private func setupImage(image: String) {
        goodImage = SKSpriteNode(imageNamed: image)
        goodImage.zPosition = 1.0
        goodImage.size = CGSize(width: 145, height: 313)
        bg.addChild(goodImage)
    }
    
    private func setupNameLabel(goodName: String) {
        goodNameLabel = SKLabelNode(fontNamed: "Hardpixel")
        goodNameLabel.text = goodName
        goodNameLabel.fontColor = status.color
        goodNameLabel.fontSize = 20
        goodNameLabel.preferredMaxLayoutWidth = bg.frame.size.width - 6
        goodNameLabel.verticalAlignmentMode = .top
        goodNameLabel.horizontalAlignmentMode = .center
        goodNameLabel.position = CGPoint(x: 0, y: bg.frame.height/2 - 10)
        bg.addChild(goodNameLabel)
    }
    
    private func setupCostLabel() {
        costLabel = SKLabelNode(fontNamed: "Hardpixel")
        if status == .locked {
            costLabel.text = "\(cost) TO UNLOCK"
        } else {
            costLabel.text = "UNLOCKED"
        }
        costLabel.fontColor = status.color
        costLabel.fontSize = 20
        costLabel.preferredMaxLayoutWidth = bg.frame.size.width - 6
        costLabel.verticalAlignmentMode = .bottom
        costLabel.horizontalAlignmentMode = .center
        costLabel.position = CGPoint(x: 0, y: -bg.frame.height/2 + 10)
        bg.addChild(costLabel)
    }
}

//MARK: - Actions

extension Good {

    private func updateBtn() {
        var alpha: CGFloat = 1.0
        if isInside {
            alpha = 0.7
        }
        
        self.run(.fadeAlpha(to: alpha, duration: 0.2))
    }
    
    func onSelect() {
        print("qwe")
        switch status {
        case .bought:
            (action ?? {})()
            shopScene.chooseGood(choosen: self)
        case .choosen:
            break
        case .locked:
            let balance = UserDefaults.standard.integer(forKey: balanceKey)
            if balance >= cost {
                shopScene.showAllert(good: self)
            } else {
                shopScene.redAnimationBalance()
            }
        }
    }
    
    func setNewStatus(newStatus: GoodStatus) {
        UserDefaults.standard.set(newStatus.rawValue, forKey: self.name!)
        status = newStatus
        bg.strokeColor = newStatus.color
        goodNameLabel.fontColor = newStatus.color
        costLabel.fontColor = newStatus.color
        if newStatus == .locked {
            costLabel.text = "\(cost) TO UNLOCK"
        } else {
            costLabel.text = "UNLOCKED"
        }
    }
}

