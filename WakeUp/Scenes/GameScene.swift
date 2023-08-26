//
//  GameScene.swift
//  WakeUp
//
//  Created by Nik Y on 23.07.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //MARK: - Properties
    private var bgNode: SKSpriteNode!
    private var subBGNode: SKSpriteNode!
    private var bedrooms: [BedroomNode] = []
    private(set) var customClock: CustomClockNode!
    private var dayNode: DayNode!
    private var scoreNode: ScoreNode!
    private var speedSettingsNode: SpeedSettingsNode!
    private var blackoutNode: SKShapeNode!
    private var stopBtn: MyButton!
    private var alertNode: AlertNode!
    private var questionBtn: MyButton!
    private var tutorial: SKSpriteNode!
    
    //MARK: - Settings
    private(set) var bedroomsCount: Int!
    private var numOfAwakened: Int = 0
    private var gameSpeed: Double = 1
    private var complication: Double = 0.8
    private var isTimeSkipping: Bool = false
    
    //MARK: - Initializes
    init(size: CGSize, bedroomsCount: Int) {
        super.init(size: size)
        self.bedroomsCount = bedroomsCount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        
        let loc = touch.location(in: self)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        customClock.update(currentTime)
        if !isTimeSkipping {
            if customClock.timeElapsed > 540 || numOfAwakened == bedrooms.count {
                newDay()
            }
        }
    }
}

//MARK: - Setups

extension GameScene {
    
    private func setupNodes() {
        //TODO: - BackgroundNode
        addBG()
        
        //TODO: - GameRectangle
        setupGameRectangle(bedroomsCount: bedroomsCount)
        
        setupCustomClock()
        setupDayNode()
        setupScoreLabel()
        setupSpeedSettingsLabels()
        setupBlackoutNode()
        setupStopBtn()
        setupAlertNode()
        setupQuestionBtn()
        setupTutorial()
        if bedroomsCount == 1 {
            (questionBtn.action ?? {})()
        }
    }
}

//MARK: - BackgroundNode

extension GameScene {
    
    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background1")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        let aspectRatio = bgNode.size.width / bgNode.size.height
        bgNode.size = CGSize(width: screenSize.height * aspectRatio, height: screenSize.height)
        addChild(bgNode)
    }
}

//MARK: - GameRectangle

extension GameScene {
    
    private func setupGameRectangle(bedroomsCount: Int) {
        setupSubBG()
        setupBedrooms(count: bedroomsCount)
    }
    
    private func setupSubBG() {
        subBGNode = SKSpriteNode(imageNamed: "sub_background")
        subBGNode.zPosition = 0.0
        subBGNode.size = CGSize(width: 311, height: 509)
        subBGNode.position = CGPoint(x: frame.midX, y: frame.maxY - 250 - subBGNode.size.height/2)
        addChild(subBGNode)
    }
    
    private func setupBedrooms(count: Int) {
        for i in bedrooms.count..<count {
            let newBedroom = BedroomNode(name: "bedroom1_\(i+1)", gameScene: self)
            bedrooms.append(newBedroom)
            subBGNode.addChild(newBedroom)
        }
        bedrooms.forEach({
            $0.setScale(count < 3 ? 1.26 : 1.1)
        })
        let bedSize = bedrooms[0].calculateAccumulatedFrame().size
        switch count {
        case 1:
            bedrooms[0].position = CGPoint(x: 0, y: 0)
        case 2:
            bedrooms[0].position = CGPoint(x: 0, y: bedSize.height/2 + 6)
            bedrooms[1].position = CGPoint(x: 0, y: -bedSize.height/2 - 6)
        case 4:
            bedrooms[0].position = CGPoint(x: -bedSize.width/2 - 2.5, y: bedSize.height/2 + 3)
            bedrooms[1].position = CGPoint(x: bedSize.width/2 + 2.5, y: bedSize.height/2 + 3)
            bedrooms[2].position = CGPoint(x: -bedSize.width/2 - 2.5, y: -bedSize.height/2 - 3)
            bedrooms[3].position = CGPoint(x: bedSize.width/2 + 2.5, y: -bedSize.height/2 - 3)
        case 6:
            bedrooms[0].position = CGPoint(x: -bedSize.width/2 - 2.5, y: bedSize.height + 5)
            bedrooms[1].position = CGPoint(x: -bedSize.width/2 - 2.5, y: 0)
            bedrooms[2].position = CGPoint(x: -bedSize.width/2 - 2.5, y: -bedSize.height - 3)
            bedrooms[3].position = CGPoint(x: bedSize.width/2 + 2.5, y: bedSize.height + 5)
            bedrooms[4].position = CGPoint(x: bedSize.width/2 + 2.5, y: 0)
            bedrooms[5].position = CGPoint(x: bedSize.width/2 + 2.5, y: -bedSize.height - 3)
        default:
            print("New count of beds: \(count) ??")
        }
    }
    
    private func setupSpeedSettingsLabels() {
        speedSettingsNode = SpeedSettingsNode(gameScene: self)
        subBGNode.addChild(speedSettingsNode)
        let speedSize = speedSettingsNode.calculateAccumulatedFrame().size
        speedSettingsNode.position = CGPoint(x: 0, y: -subBGNode.size.height/2 - speedSize.height/2 - 4)
    }
    
    private func setupCustomClock() {
        customClock = CustomClockNode()
        let size = customClock.calculateAccumulatedFrame().size
        customClock.position = CGPoint(x: -subBGNode.size.width/2 + size.width/2, y: subBGNode.size.height/2 + size.height/2 + 1)
        subBGNode.addChild(customClock)
    }
    
    private func setupDayNode() {
        dayNode = DayNode()
        dayNode.position = CGPoint(x: 0, y: customClock.position.y)
        subBGNode.addChild(dayNode)
    }
    
    private func setupScoreLabel() {
        scoreNode = ScoreNode()
        let size = scoreNode.calculateAccumulatedFrame().size
        scoreNode.position = CGPoint(x: subBGNode.size.width/2 - size.width/2, y: subBGNode.size.height/2 + size.height/2 + 1)
        subBGNode.addChild(scoreNode)
    }
    
    private func setupBlackoutNode() {
        blackoutNode = SKShapeNode(rect: self.frame)
        blackoutNode.fillColor = UIColor(hex: 0x000000, alpha: 0.5)
        blackoutNode.lineWidth = 0
        blackoutNode.zPosition = 49.0
        blackoutNode.isHidden = true
        addChild(blackoutNode)
    }
    
    private func setupStopBtn() {
        stopBtn = MyButton(rectangleSize: CGSize(width: 51, height: 51), cornerRadius: 10, rectangleColor: .black, strokeColor: .red, text: "STOP", textColor: .red, fontSize: 16)
        stopBtn.action = {
            self.alertNode.isHidden = false
            self.setTimeSpeed(newSpeed: -1)
        }
        stopBtn.zPosition = 1.0
        let sizeSelf = stopBtn.calculateAccumulatedFrame().size
        let sizeScoreNode = scoreNode.calculateAccumulatedFrame().size
        stopBtn.position = CGPoint(x: subBGNode.size.width/2 - sizeSelf.width/2, y: scoreNode.position.y + sizeScoreNode.height/2 + sizeSelf.height/2 + 1)
        subBGNode.addChild(stopBtn)
    }
    
    private func setupAlertNode() {
        alertNode = AlertNode(
            message: "Do you really want to stop the game? The points scored will be transferred to the balance.",
            cancelAction: {
                self.alertNode.isHidden = true
                self.setTimeSpeed(newSpeed: -2)
            },
            acceptAction: {
                let scene = GameOverScene(size: screenSize, score: self.scoreNode.score, bedroomsCount: self.bedroomsCount)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
            })
        alertNode.isHidden = true
        alertNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(alertNode)
    }
    
    private func setupQuestionBtn() {
        questionBtn = MyButton(imageNamed: "questionBtn", size: CGSize(width: 51, height: 51))
        questionBtn.action = { [self] in
            tutorial.isHidden.toggle()
            blackoutNode.isHidden.toggle()
            questionBtn.zPosition = blackoutNode.isHidden ? 1.0 : 51.0
            setTimeSpeed(newSpeed: blackoutNode.isHidden ? -2 : -1)
        }
        
        let sizeSelf = questionBtn.calculateAccumulatedFrame().size
        let sizeClockNode = customClock.calculateAccumulatedFrame().size
        questionBtn.position = CGPoint(x: -subBGNode.size.width/2 + sizeSelf.width/2 + 1, y: customClock.position.y + sizeClockNode.height/2 + sizeSelf.height/2 + 1)
        subBGNode.addChild(questionBtn)
    }
    
    private func setupTutorial() {
        tutorial = SKSpriteNode(imageNamed: "tutorial")
        tutorial.zPosition = 51.0
        tutorial.isHidden = true
        tutorial.position = subBGNode.position
        addChild(tutorial)
    }
}

//MARK: - Actions

extension GameScene {
    
    // -1: пауза без штрафа
    // -2: снять с паузы
    func setTimeSpeed(newSpeed: TimeInterval) {
        var speed = newSpeed
        if speed == -1 {
            speed = 0
        } else if speed == -2 {
            speed = gameSpeed
        } else {
            if speed == 0 {
                subtractScore(by: 1)
            }
            gameSpeed = speed
        }
        
        customClock.changeSpeed(newSpeed: speed * complication)
        bedrooms.forEach({
            $0.setIndicatorSpeed(speed: speed * complication)
        })
    }
    
    func newDay() {
        isTimeSkipping = true
        run(.sequence([
            .run { [self] in
                if dayNode.day % 5 == 0 {
                    addScore(by: bedroomsCount)
                }
                speedSettingsNode.isUserInteractionEnabled = false
                bedrooms.forEach({
                    $0.newDay()
                })
                customClock.newDay()
                numOfAwakened = 0
                //TODO: Animation of bg
            },
            .wait(forDuration: 3)]),
            completion: {
            self.speedSettingsNode.isUserInteractionEnabled = true
            self.dayNode.addDay(by: 1)
            self.complication += 0.1
            self.setTimeSpeed(newSpeed: self.gameSpeed)
            self.isTimeSkipping = false
        })
    }
    
    func oneWokeUp() {
        numOfAwakened += 1
    }
    
    func addScore(by num: Int) {
        scoreNode.addScore(by: num)
    }
    
    func subtractScore(by num: Int) {
        scoreNode.subtractScore(by: num)
    }
    
    func gameOverAnimate(loser: BedroomNode) {
        loser.zPosition = 50.0
        blackoutNode.isHidden = false
        self.run(.wait(forDuration: 1.9),completion: {
            let scene = GameOverScene(size: screenSize, score: self.scoreNode.score, bedroomsCount: self.bedroomsCount)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        })
    }
}
