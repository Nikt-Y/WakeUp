//
//  CustomClockNode.swift
//  WakeUp
//
//  Created by Nik Y on 20.08.2023.
//

import SpriteKit

class CustomClockNode: SKNode {
    
    //MARK: - Properties
    private var timeLabel = SKLabelNode()
    private var bg = SKShapeNode()
    
    // need for time transition
    private struct TimeTransition {
        let startTime: TimeInterval
        let duration: TimeInterval
        let originalTimeElapsed: TimeInterval
        let targetTimeDifference: TimeInterval
    }

    private var startTime: TimeInterval?
    private(set) var timeElapsed: TimeInterval = 330
    private var speedMultiplier: TimeInterval = 1
    private var isTransitioning = false
    private var timeTransition: TimeTransition?
    
    //MARK: - Initializes
    override init() {
        super.init()

        startTime = CACurrentMediaTime()
        setupBG()
        setupTimeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setups

extension CustomClockNode {
    
    private func setupBG() {
        bg = SKShapeNode(rectOf: CGSize(width: 118, height: 48), cornerRadius: 5)
        bg.fillColor = .init(hex: 0x011687)
        bg.lineWidth = 4
        bg.strokeColor = .black
        bg.zPosition = 1.0
        addChild(bg)
    }
    
    func setupTimeLabel() {
        timeLabel = SKLabelNode(fontNamed: "Hardpixel")
        timeLabel.fontSize = 40
        timeLabel.text = "00:00"
        timeLabel.zPosition = 2.0
        timeLabel.fontColor = .cyan
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.position = CGPoint(x: -bg.frame.width/2 + 9, y: -timeLabel.frame.height/2)
        bg.addChild(timeLabel)
    }
}

//MARK: - Actions

extension CustomClockNode {
    
    func update(_ currentTime: TimeInterval) {
        if isTransitioning, let transition = timeTransition {
            let progress = (currentTime - transition.startTime) / transition.duration
            if progress < 1 {
                timeElapsed = transition.originalTimeElapsed + transition.targetTimeDifference * progress
            } else {
                timeElapsed = transition.originalTimeElapsed + transition.targetTimeDifference
                self.timeTransition = nil
                isTransitioning = false
                startTime = currentTime
            }
        }
        
        if let startTimeValue = startTime, !isTransitioning {
            timeElapsed += (currentTime - startTimeValue) * speedMultiplier
            startTime = currentTime
        }
        
        if timeElapsed > 1440 {
            timeElapsed = TimeInterval(Int(timeElapsed) % 1440)
        }
        let hours = Int(timeElapsed) / 60
        let minutes = Int(timeElapsed) % 60
        timeLabel.text = String(format: "%02d:%02d", hours, minutes)
    }
    
    func changeSpeed(newSpeed: TimeInterval) {
        speedMultiplier = newSpeed
        startTime = newSpeed == 0 ? nil : CACurrentMediaTime()
    }
    
    func newDay() {
        goToTime(time: 1785, duration: 3)
    }

    private func goToTime(time: TimeInterval, duration: TimeInterval) {
        let targetTimeDifference = time - timeElapsed
        let transitionStartTime = CACurrentMediaTime()
        timeTransition = TimeTransition(startTime: transitionStartTime, duration: duration, originalTimeElapsed: timeElapsed, targetTimeDifference: targetTimeDifference)
        isTransitioning = true
    }
}
