//
//  BedroomNode.swift
//  WakeUp
//
//  Created by Nik Y on 28.07.2023.
//

import SpriteKit

class BedroomNode: SKNode {
    
    //MARK: - Properties
    private var node = SKShapeNode()
    private var bedroomNode = SKSpriteNode()
    private var healthNode = SKNode()
    private var timeLabel = SKLabelNode()
    private var stageLine = SKSpriteNode()
    private var stageIndicator = SKSpriteNode()
    private var label = SKLabelNode()
    private var nearlyCount = 0
    private var excellentCount = 0
    
    // MARK: - Settings
    private var direction: MovementDirection = .right {
        didSet {
            if direction == .right {
                stageLine.texture = .init(imageNamed: "stageLineRight")
            } else {
                stageLine.texture = .init(imageNamed: "stageLineLeft")
            }
        }
    }
    private var startIndPos: Double = 0 // 0...1
    private var indicatorSpeed: CGFloat = 1.0
    private var healthCount: Int {
        didSet {
            setupHealthNode()
        }
    }
    private var time: Int
    private var gameScene: GameScene
    private(set) var isAwakened: Bool = false {
        didSet {
            if isAwakened {
                gameScene.oneWokeUp()
            }
        }
    }
    
    //MARK: - Initializes
    init(name: String, gameScene: GameScene, time: Int = 360, health: Int = 3) {
        self.time = time
        self.healthCount = health
        self.gameScene = gameScene
        
        super.init()
        self.name = name

        isUserInteractionEnabled = true
        setupNode()
        setupBedroomNode()
        setupHealthNode()
        setupTimeLabel()
        setupStatusLabel()
        setupStageLine()
        setupStageIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        wakeUp()
    }
}

//MARK: - Setups

extension BedroomNode {
    
    private func setupNode() {
        node = SKShapeNode(rectOf: CGSize(width: 127, height: 145), cornerRadius: 5)
        node.fillColor = UIColor(hex: 0x000000)
        node.strokeColor = UIColor(hex: 0x000000)
        node.zPosition = 5.0
        addChild(node)
    }
    
    private func setupBedroomNode() {
        bedroomNode = SKSpriteNode(imageNamed: self.name ?? "bedroom1_1")
        bedroomNode.position = CGPoint(x: 0, y: 9)
        bedroomNode.size = CGSize(width: 118, height: 118)
        bedroomNode.zPosition = 6.0
        addChild(bedroomNode)
    }
    
    private func setupHealthNode() {
        if (healthNode.parent != nil) {
            healthNode.removeFromParent()
        }
        healthNode = SKNode()
        healthNode.position = CGPoint(x: -node.frame.size.width/2 + 3, y: -node.frame.size.height/2 + 3)
        healthNode.zPosition = 6.0
        addChild(healthNode)
        let scaleBig = SKAction.scale(to: 1.5, duration: 0.05)
        let scaleNorm = SKAction.scale(to: 1.0, duration: 0.05)
        let scale = SKAction.sequence([scaleBig, scaleNorm])
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        
        for i in 0..<healthCount {
            let heart = SKSpriteNode(imageNamed: "heart")
            heart.size = CGSize(width: 14, height: 14)
            heart.setScale(0.9)
            heart.position = CGPoint(x: CGFloat(i*17), y: 0)
            heart.alpha = 0.0
            heart.anchorPoint = CGPoint(x: 0, y: 0)
            healthNode.addChild(heart)
            heart.run(.sequence([.wait(forDuration: 0.2*Double(i)) ,fadeIn, scale]))
        }
    }
    
    private func setupTimeLabel() {
        timeLabel = SKLabelNode(fontNamed: "Helvetica")
        timeLabel.text = "7:00"
        timeLabel.fontSize = 15
        timeLabel.fontColor = SKColor.white
        timeLabel.zPosition = 6.0
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.verticalAlignmentMode = .bottom
        
        timeLabel.position = CGPoint(x: node.frame.size.width/2 - 3, y: -node.frame.size.height/2 + 3)
        
        addChild(timeLabel)
        setNewTimeWithAnimation()
    }
    
    private func setupStageLine() {
        stageLine = SKSpriteNode(imageNamed: "stageLineRight")
        stageLine.size = CGSize(width: 109, height: 7)
        stageLine.anchorPoint = CGPoint(x: 0, y: 1)
        stageLine.position = CGPoint(x: -node.frame.width/2 + 9, y: node.frame.height/2 - 40)
        stageLine.zPosition = 7.0
        addChild(stageLine)
    }
    
    private func setupStageIndicator() {
        stageIndicator = SKSpriteNode(imageNamed: "stick")
        stageIndicator.size = CGSize(width: 5, height: 14)
        startIndPos = Double.random(in: 0...1)
        direction = Bool.random() ? .left : .right
        stageIndicator.position = CGPoint(x: CGFloat(Double(stageLine.frame.width) * startIndPos), y: -stageLine.frame.height/2)
        stageIndicator.zPosition = 8.0
        stageLine.addChild(stageIndicator)
    }
    
    private func setupStatusLabel() {
        label = SKLabelNode(fontNamed: "Hardpixel")
        label.position = CGPoint(x: 0, y: 0)
        
        label.fontSize = 25
        label.alpha = 0.0
        label.setScale(0.9)
        label.zPosition = 9.0
        node.addChild(label)
        
    }
}

// MARK: - Actions

extension BedroomNode {
    
    func setIndicatorSpeed(speed: CGFloat) {
        if isAwakened {
            return
        }
        stopActions()
        self.indicatorSpeed = speed
        startStageIndicatorAnimation()
    }
    
    private func stopActions() {
        stageIndicator.removeAllActions()
    }
    
    func getCurrentStage() -> Status {
        let current = stageIndicator.position.x/stageLine.size.width
        if current > 0.43 && current < 0.58 {
            return .excellent
        } else if current > 0.33 && current < 0.67 {
            return .good
        } else {
            return .bad
        }
    }
    
    func wakeUp() {
        isUserInteractionEnabled = false
        stopActions()
        isAwakened = true
        let timeDif = TimeInterval(time) - gameScene.customClock.timeElapsed
        let stage = getCurrentStage()
        if stage == .good || stage == .excellent {
            if timeDif < -10 {
                getDamage()
                startStatusAnimation(status: .overslept)
            } else if timeDif > 100 {
                getDamage()
                startStatusAnimation(status: .early)
            } else if timeDif < 0 {
                startStatusAnimation(status: .nearly)
                gameScene.addScore(by: 1)
                self.run(.playSoundFileNamed("success.mp3", waitForCompletion: false))
            } else {
                startStatusAnimation(status: stage)
                gameScene.addScore(by: 2)
                self.run(.playSoundFileNamed("success.mp3", waitForCompletion: false))
            }
        } else {
            startStatusAnimation(status: .bad)
            getDamage()
        }
    }
    
    func getDamage() {
        guard healthCount > 0 else { return }
        let toRed = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.3)
        let toOrig = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.3)
        let alarmSound = SKAction.playSoundFileNamed("alarm.mp3", waitForCompletion: false)
        let badSound = SKAction.playSoundFileNamed("bad.mp3", waitForCompletion: false)
        healthCount -= 1
        if healthCount == 0 {
            gameScene.gameOverAnimate(loser: self)
            bedroomNode.run(.repeat(.sequence([alarmSound, toRed, toOrig]), count: 3))
        } else {
            bedroomNode.run(.repeat(.sequence([badSound, toRed, toOrig]), count: 1))
        }
    }
    
    func startStatusAnimation(status: Status) {
        countStatuses(status: status)
        label.removeAllActions()
        self.label.position = CGPoint(x: 0, y: 0)
        self.label.setScale(0.9)
        label.text = status.rawValue
        label.fontColor = status.color
        let goUp = SKAction.moveTo(y: 30, duration: 1.1)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let sizeBig = SKAction.scale(to: 1.2, duration: 0.2)
        let sizeNormal = SKAction.scale(to: 1.0, duration: 0.2)
        let fade = SKAction.sequence([fadeIn, .wait(forDuration: 0.6) ,fadeOut])
        let size = SKAction.sequence([sizeBig, sizeNormal])
        label.run(.group([goUp, fade, size]), completion: {
            self.label.position = CGPoint(x: 0, y: 0)
            self.label.setScale(0.9)
        })
        node.strokeColor = status.color
    }
    
    func countStatuses(status: Status) {
        switch status {
        case .excellent:
            excellentCount += 1
            if excellentCount == 3 {
                if healthCount < 5 {
                    healthCount += 1
                }
                excellentCount = 0
            }
            nearlyCount = 0
        case .nearly:
            nearlyCount += 1
            if nearlyCount == 2 {
                getDamage()
                nearlyCount = 0
            }
            excellentCount = 0
        default:
            excellentCount = 0
            nearlyCount = 0
        }
    }
    
    func startStageIndicatorAnimation() {
        guard indicatorSpeed > 0 else {
            return
        }
        let leftEdge: Double = 0
        let rightEdge = stageLine.size.width
        
        let goEdge: SKAction
        let currentIndPos = stageIndicator.position.x/stageLine.size.width
        if direction == .right {
            goEdge = SKAction.moveTo(x: rightEdge, duration: (1-currentIndPos) * (100/indicatorSpeed))
        } else {
            goEdge = SKAction.moveTo(x: leftEdge, duration: currentIndPos * (100/indicatorSpeed))
        }
        stageIndicator.run(goEdge, completion: {
            self.direction = self.direction == .left ? .right : .left
            self.startStageIndicatorAnimation()
        })
    }
    
    func newDay() {
        stopActions()
        if !isAwakened {
            startStatusAnimation(status: .overslept)
            getDamage()
        }
        isAwakened = false
        run(.sequence([
            .wait(forDuration: 2.5),
            .run {
                self.setNewTimeWithAnimation()
                self.setNewSleepStageWithAnimation()
            },
            .wait(forDuration: 0.5)
        ]), completion: {
            self.node.strokeColor = .black
            self.startStageIndicatorAnimation()
            self.isUserInteractionEnabled = true
        })
    }
    
    private func setNewSleepStageWithAnimation() {
        var newPos: CGFloat = 0
        direction = Bool.random() ? .left : .right
        if time < 390 {
            if direction == .right {
                newPos = CGFloat.random(in: 0...stageLine.size.width*0.3)
            } else {
                newPos = CGFloat.random(in: stageLine.size.width*0.67...stageLine.size.width)
            }
        } else {
            newPos = CGFloat.random(in: 0...stageLine.size.width)
        }
        stageIndicator.run(.moveTo(x: newPos, duration: 0.3))
    }
    
    private func setNewTimeWithAnimation() {
        time = Int.random(in: 360...525)
        let hours = time / 60
        let minutes = time % 60
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let changeText = SKAction.run {
            self.timeLabel.text = String(format: "%d:%02d", hours, minutes)
        }
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let sequence = SKAction.sequence([fadeOut, changeText, fadeIn])
        timeLabel.run(sequence)
    }
}
