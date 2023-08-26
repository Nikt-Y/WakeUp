//
//  AlertNode.swift
//  WakeUp
//
//  Created by Nik Y on 24.08.2023.
//

import SpriteKit

class AlertNode: SKNode {
    //MARK: - Properties
    private var blackout: SKShapeNode!
    private var node: SKShapeNode!
    private var headerNode: SKLabelNode!
    private var messageNode: SKLabelNode!
    private var cancelBtn: MyButton!
    private var acceptBtn: MyButton!
    
    //MARK: - Settings
    private var header: String!
    private var message: String!
    private var cancelAction: (() -> ())!
    private var acceptAction: (() -> ())!
    
    //MARK: - Initializes
    init(message: String, cancelAction: @escaping () -> (), acceptAction: @escaping () -> (), header: String = "Attention!") {
        super.init()
        self.header = header
        self.message = message
        self.acceptAction = acceptAction
        self.cancelAction = cancelAction

        isUserInteractionEnabled = true
        setupBlackout()
        setupLabels()
        setupBG()
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setups

extension AlertNode {
    
    private func setupBlackout() {
        blackout = SKShapeNode(rectOf: screenSize)
        blackout.fillColor = UIColor(hex: 0x000000, alpha: 0.8)
        blackout.lineWidth = 0
        blackout.zPosition = 49.0
        addChild(blackout)
    }
    
    private func setupLabels() {
        messageNode = SKLabelNode(fontNamed: "Hardpixel")
        messageNode.preferredMaxLayoutWidth = 254
        messageNode.fontSize = 16
        messageNode.text = message
        messageNode.zPosition = 51.0
        messageNode.fontColor = .cyan
        messageNode.numberOfLines = 0
        messageNode.horizontalAlignmentMode = .center
        addChild(messageNode)
        
        headerNode = SKLabelNode(fontNamed: "Hardpixel")
        headerNode.preferredMaxLayoutWidth = 254
        headerNode.fontSize = 25
        headerNode.text = header
        headerNode.zPosition = 51.0
        headerNode.fontColor = .cyan
        headerNode.horizontalAlignmentMode = .center
        headerNode.position = CGPoint(x: 0, y: messageNode.frame.height + 9)
        addChild(headerNode)
    }
    
    private func setupBG() {
        node = SKShapeNode(rectOf: CGSize(width: 272, height: headerNode.frame.height + messageNode.frame.height + 85), cornerRadius: 24)
        node.fillColor = .init(hex: 0x00126F)
        node.lineWidth = 1
        node.strokeColor = .cyan
        node.position = CGPoint(x: 0, y: headerNode.position.y + headerNode.frame.height + 5 - node.frame.height/2)
        node.zPosition = 50.0
        addChild(node)
    }
    
    private func setupButtons() {
        let btnsSize = CGSize(width: 110, height: 32)
        cancelBtn = MyButton(rectangleSize: btnsSize, cornerRadius: 20, rectangleColor: .black, strokeColor: .red, text: "CANCEL", textColor: .red, fontSize: 14)
        cancelBtn.action = cancelAction
        cancelBtn.zPosition = 51.0
        cancelBtn.position = CGPoint(x: -node.frame.size.width/2 + btnsSize.width/2 + 19, y: -node.frame.height/2 + btnsSize.height/2 + 16)
        node.addChild(cancelBtn)
        
        acceptBtn = MyButton(rectangleSize: btnsSize, cornerRadius: 20, rectangleColor: .black, strokeColor: .green, text: "ACCEPT", textColor: .green, fontSize: 14)
        acceptBtn.action = acceptAction
        acceptBtn.zPosition = 51.0
        acceptBtn.position = CGPoint(x: node.frame.size.width/2 - btnsSize.width/2 - 19, y: -node.frame.height/2 + btnsSize.height/2 + 16)
        node.addChild(acceptBtn)
    }
}
