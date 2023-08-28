//
//  MySKScroll.swift
//  WakeUp
//
//  Created by Nik Y on 26.08.2023.
//

import SpriteKit

class MySKScroll: SKNode {
    //MARK: - Properties
    private var node: SKSpriteNode!
    private var topLine: SKSpriteNode!
    private var crop: SKCropNode!
    private var content: SKNode!
    private var size: CGSize!
    private var scrollSize: CGFloat = 0
    private var offset: CGFloat!
    private var row: CGFloat = 0
    private var nodeCount: CGFloat = 0
    
    //MARK: - Initializes
    init(size: CGSize, offset: CGFloat) {
        super.init()
        
        self.offset = offset
        self.size = size
        isUserInteractionEnabled = true
        
        node = SKSpriteNode(color: .clear, size: size)
        node.zPosition = 2.0
        addChild(node)
        
        topLine = SKSpriteNode(imageNamed: "topLine")
        topLine.size = CGSize(width: screenSize.width, height: 9)
        topLine.zPosition = 3.0
        topLine.anchorPoint = CGPoint(x: 0.5, y: 1)
        topLine.position = CGPoint(x: 0, y: size.height/2)
        node.addChild(topLine)
        
        crop = SKCropNode()
        crop.maskNode = SKSpriteNode(color: .red, size: size)
        addChild(crop)
        
        content = SKNode()
        crop.addChild(content)
        content.position = CGPoint(x: -size.width/2, y: size.height/2)
        initialPositionY = content.position.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    var initialTouch: CGPoint?
    private var initialPositionY: CGFloat!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        initialTouch = touches.first?.location(in: self)
        
        if let touch = touches.first {
            let location = touch.location(in: self.content)
            
            for child in self.content.children {
                let childFrame = child.calculateAccumulatedFrame()
                if childFrame.contains(location) {
                    child.touchesBegan([touch], with: event)
                }
            }
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let initialTouch = initialTouch, let currentTouch = touches.first?.location(in: self) else {
            return
        }

        let dy = (currentTouch.y - initialTouch.y) * 1.3
        var newY = content.position.y + dy

        newY = max(min(newY, initialPositionY + scrollSize), initialPositionY)
        content.position.y = newY

        self.initialTouch = currentTouch
        
        if let touch = touches.first {
            let location = touch.location(in: self.content)
            
            for child in self.content.children {
                let childFrame = child.calculateAccumulatedFrame()
                if childFrame.contains(location) {
                    child.touchesMoved([touch], with: event)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self.content)
            for child in self.content.children {
                let childFrame = child.calculateAccumulatedFrame()
                if childFrame.contains(location) {
                    child.touchesEnded([touch], with: event)
                }
            }
        }
    }
}

//MARK: - Actions

extension MySKScroll {
    
    func addScrollChild(_ node: SKNode) {
        nodeCount += 1
        let nodeSize = node.calculateAccumulatedFrame().size
        if nodeCount*nodeSize.width + 2*offset > size.width {
            row += 1
            nodeCount = 1
        }
        let x = (nodeCount-1)*nodeSize.width + nodeCount*offset + nodeSize.width/2
        let y = -row*nodeSize.height - (row+1)*offset - nodeSize.height/2
        node.position = CGPoint(x: x, y: y)
        self.content.addChild(node)
        scrollSize = -y + nodeSize.height/2 + offset - size.height
    }
}

