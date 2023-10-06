//
//  SpeedSettingsNode.swift
//  WakeUp
//
//  Created by Nik Y on 17.08.2023.
//

import SpriteKit

class SpeedSettingsNode: SKNode {
    //MARK: - Properties
    private var node = SKShapeNode()
    private var label05 = SKLabelNode()
    private var label1 = SKLabelNode()
    private var label2 = SKLabelNode()
    private var pauseBtn = SKSpriteNode()
    
    //MARK: - Settings
    private var isRunning: Bool = true
    var gameScene: GameScene?
    
    //MARK: - Initializes
    override init() {
        super.init()
        isUserInteractionEnabled = true
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
        
        isUserInteractionEnabled = true
        setupNode()
        setupLabelsAndButtons()
        setNewSpeed(nodeName: "x1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        setNewSpeed(nodeName: node.name ?? "")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
    }
}

//MARK: - Setups

extension SpeedSettingsNode {
    
    private func setupNode() {
        node = SKShapeNode(rectOf: CGSize(width: 311, height: 49), cornerRadius: 10)
        node.name = "bg"
        node.fillColor = .black
        node.strokeColor = .black
        node.zPosition = 1.0
        addChild(node)
    }
    
    private func setupLabelsAndButtons() {
        label05 = SKLabelNode(fontNamed: "Hardpixel")
        label1 = SKLabelNode(fontNamed: "Hardpixel")
        label2 = SKLabelNode(fontNamed: "Hardpixel")
        
        pauseBtn = SKSpriteNode(imageNamed: "pauseW")
        pauseBtn.name = "pause"
        pauseBtn.size = CGSize(width: 28, height: 33)
        pauseBtn.zPosition = 2.0

        let labels: [SKLabelNode] = [label05, label1, label2]
        let allElements: [SKNode] = labels + [pauseBtn]

        // Set common properties for labels
        for label in labels {
            label.fontSize = 35
            label.fontColor = .white
            label.zPosition = 2.0
        }

        label05.name = "x0.5"
        label05.text = "x0.5"

        label1.name = "x1"
        label1.text = "x1"

        label2.name = "x2"
        label2.text = "x2"

        // Calculate the total width of all elements
        var totalWidth: CGFloat = 0
        for element in allElements {
            totalWidth += element.calculateAccumulatedFrame().width
        }

        // Calculate the space between elements
        let spaceBetweenElements = (node.frame.size.width - totalWidth) / CGFloat(allElements.count + 1)

        // Position the elements with equal spacing
        var currentX: CGFloat = -node.frame.size.width/2 + spaceBetweenElements
        for element in allElements {
            currentX += element.calculateAccumulatedFrame().width/2
            element.position = CGPoint(x: currentX, y: element is SKLabelNode ? -node.frame.height/4 : 0)
            node.addChild(element)
            currentX += element.calculateAccumulatedFrame().width/2 + spaceBetweenElements
        }
    }


}

//MARK: - Actions

extension SpeedSettingsNode {
    
    private func setNewSpeed(nodeName: String) {
        setColorForButton(btnName: nodeName)
        switch nodeName {
        case "x0.5":
            gameScene?.setTimeSpeed(newSpeed: 1)
        case "x1":
            gameScene?.setTimeSpeed(newSpeed: 2)
        case "x2":
            gameScene?.setTimeSpeed(newSpeed: 4)
        case "pause":
            gameScene?.setTimeSpeed(newSpeed: 0)
        default:
            break
        }
    }
    
    private func setColorForButton(btnName: String) {
        guard btnName != "bg" else { return }
        let labels: [SKLabelNode] = [label05, label1, label2]
        
        labels.forEach({ label in
            label.fontColor = label.name == btnName ? .green : .white
        })
        
        if btnName != "pause" {
            pauseBtn.texture = .init(imageNamed: "pauseW")
        } else {
            pauseBtn.texture = .init(imageNamed: "pauseR")
        }
    }
}
