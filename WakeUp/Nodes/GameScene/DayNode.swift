//
//  DayNode.swift
//  WakeUp
//
//  Created by Nik Y on 25.08.2023.
//

import SpriteKit

class DayNode: SKNode {
    //MARK: - Properties
    private var bg: SKShapeNode!
    private var dayTitleLabel: SKLabelNode!
    private var dayNumLabel: SKLabelNode!
    
    //MARK: - Settings
    private(set) var day: Int = 1
    
    //MARK: - Initializes
    init(_ day: Int = 1) {
        super.init()
        
        self.day = day
        setupBG()
        setupDayLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setups

extension DayNode {
    
    private func setupBG() {
        bg = SKShapeNode(rectOf: CGSize(width: 60, height: 48), cornerRadius: 5)
        bg.fillColor = .init(hex: 0x011687)
        bg.lineWidth = 4
        bg.strokeColor = .black
        bg.zPosition = 1.0
        addChild(bg)
    }
    
    private func setupDayLabels() {
        dayTitleLabel = SKLabelNode(fontNamed: "Hardpixel")
        dayTitleLabel.fontSize = 20
        dayTitleLabel.text = "DAY"
        dayTitleLabel.zPosition = 2.0
        dayTitleLabel.fontColor = .cyan
        dayTitleLabel.horizontalAlignmentMode = .center
        dayTitleLabel.verticalAlignmentMode = .top
        dayTitleLabel.position = CGPoint(x: 0, y: bg.frame.height/2 - 7)
        addChild(dayTitleLabel)
        
        dayNumLabel = SKLabelNode(fontNamed: "Hardpixel")
        dayNumLabel.fontSize = 23
        dayNumLabel.text = "\(day)"
        dayNumLabel.zPosition = 2.0
        dayNumLabel.fontColor = .cyan
        dayNumLabel.horizontalAlignmentMode = .center
        dayNumLabel.verticalAlignmentMode = .bottom
        dayNumLabel.position = CGPoint(x: 0, y: -bg.frame.height/2 + 7)
        addChild(dayNumLabel)
    }
}


//MARK: - Actions

extension DayNode {
    
    func addDay(by num: Int) {
        day += num

        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        let changeText = SKAction.run {
            self.dayNumLabel.text = "\(self.day)"
        }
        let fadeIn = SKAction.fadeIn(withDuration: 0.15)
        let sequence = SKAction.sequence([fadeOut, changeText, fadeIn])
        dayNumLabel.run(sequence)
    }
}

