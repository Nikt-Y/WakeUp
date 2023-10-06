//
//  HomeScene.swift
//  WakeUp
//
//  Created by Nik Y on 23.08.2023.
//

import SpriteKit

class HomeScene: SKScene {
    //MARK: - Properties
    private var bgNode = SKSpriteNode()
    private var playBG = SKSpriteNode()
    private var tutorialBtn = MyButton()
    private var easyModeBtn = MyButton()
    private var mediumModeBtn = MyButton()
    private var hardModeBtn = MyButton()
    private var shopBtn = MyButton()
    
    //MARK: - Settings
    private let highscore: Int
    
    //MARK: - Initializes
    override init(size: CGSize) {
        self.highscore = UserDefaults.standard.integer(forKey: highscoreKey)

        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        BackgroundMusicManager.shared.setupBackgroundMusic(forScene: self, withFiles: ["startBackgroundMusic"], repeatForever: true)
        setupBGnode()
        setupPlayBG()
        setupTutorialBtn()
        setupEasyModeBtn()
        setupMediumModeBtn()
        setupHardModeBtn()
        setupShopBtn()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

//MARK: - Setups

extension HomeScene {
    
    private func setupBGnode() {
        let bgName = UserDefaults.standard.string(forKey: bgKey) ?? "background1"
        bgNode = SKSpriteNode(imageNamed: bgName)
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        let aspectRatio = bgNode.size.width / bgNode.size.height
        bgNode.size = CGSize(width: screenSize.height * aspectRatio, height: screenSize.height)
        addChild(bgNode)
    }
    
    private func setupPlayBG() {
        playBG = SKSpriteNode(imageNamed: "playBG")
        playBG.size = CGSize(width: 280, height: 360)
        playBG.zPosition = 0.0
        playBG.position = CGPoint(x: frame.midX, y: frame.midY + 35)
        addChild(playBG)
    }
    
    private func setupTutorialBtn() {
        tutorialBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .init(hex: 0x00126F), strokeColor: .cyan, text: "TUTORIAL", textColor: .cyan, fontSize: 30)
        tutorialBtn.action = { [self] in
            let scene = GameScene(size: screenSize, bedroomsCount: 1)
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        }
        let height = tutorialBtn.calculateAccumulatedFrame().size.height
        tutorialBtn.position = CGPoint(x: 0, y: playBG.size.height/2 - height/2 - 37)
        tutorialBtn.zPosition = 1.0
        playBG.addChild(tutorialBtn)
    }
    
    private func setupEasyModeBtn() {
        let requiredScore = 1
        if highscore >= requiredScore {
            easyModeBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .init(hex: 0x00126F), strokeColor: .cyan, text: "EASY MODE", textColor: .cyan, fontSize: 30)
            easyModeBtn.action = { [self] in
                let scene = GameScene(size: screenSize, bedroomsCount: 2)
                scene.scaleMode = .aspectFill
                view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
            }
        } else {
            easyModeBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .black, strokeColor: .cyan, text: "Reach highscore \(requiredScore) to unlock", textColor: .cyan, fontSize: 20)
        }
        
        let height = tutorialBtn.calculateAccumulatedFrame().size.height
        easyModeBtn.position = CGPoint(x: 0, y: tutorialBtn.position.y - height - 18)
        easyModeBtn.zPosition = 1.0
        playBG.addChild(easyModeBtn)
    }
    
    private func setupMediumModeBtn() {
        let requiredScore = 5
        if highscore >= requiredScore {
            mediumModeBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .init(hex: 0x00126F), strokeColor: .cyan, text: "MEDIUM MODE", textColor: .cyan, fontSize: 30)
            mediumModeBtn.action = { [self] in
                let scene = GameScene(size: screenSize, bedroomsCount: 4)
                scene.scaleMode = .aspectFill
                view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
            }
        } else {
            mediumModeBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .black, strokeColor: .cyan, text: "Reach highscore \(requiredScore) to unlock", textColor: .cyan, fontSize: 20)
        }
        
        let height = easyModeBtn.calculateAccumulatedFrame().size.height
        mediumModeBtn.position = CGPoint(x: 0, y: easyModeBtn.position.y - height - 18)
        mediumModeBtn.zPosition = 1.0
        playBG.addChild(mediumModeBtn)
    }
    
    private func setupHardModeBtn() {
        let requiredScore = 15
        if highscore >= requiredScore {
            hardModeBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .init(hex: 0x00126F), strokeColor: .cyan, text: "HARD MODE", textColor: .cyan, fontSize: 30)
            hardModeBtn.action = { [self] in
                let scene = GameScene(size: screenSize, bedroomsCount: 6)
                scene.scaleMode = .aspectFill
                view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
            }
        } else {
            hardModeBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .black, strokeColor: .cyan, text: "Reach highscore \(requiredScore) to unlock", textColor: .cyan, fontSize: 20)
        }
        
        
        let height = mediumModeBtn.calculateAccumulatedFrame().size.height
        hardModeBtn.position = CGPoint(x: 0, y: mediumModeBtn.position.y - height - 18)
        hardModeBtn.zPosition = 1.0
        playBG.addChild(hardModeBtn)
    }
    
    private func setupShopBtn() {
        shopBtn = MyButton(rectangleSize: CGSize(width: 224, height: 61), cornerRadius: 10, rectangleColor: .init(hex: 0x00126F), strokeColor: .cyan, text: "SHOP", textColor: .cyan, fontSize: 30)
        shopBtn.action = { [self] in
            let scene = ShopScene(size: screenSize)
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        }
        let height = shopBtn.calculateAccumulatedFrame().size.height
        shopBtn.position = CGPoint(x: 0, y: -playBG.size.height/2 - height/2 - 10)
        shopBtn.zPosition = 1.0
        playBG.addChild(shopBtn)
    }
}
