//
//  MyButton.swift
//  WakeUp
//
//  Created by Nik Y on 24.08.2023.
//

import SpriteKit

class MyButton: SKNode {
    
    // MARK: - Properties
    var action: (() -> ())?
    var rectangle: SKShapeNode!
    var label: SKLabelNode!
    var spriteNode: SKSpriteNode!
    
    private var isInside = false {
        didSet {
            updateBtn()
        }
    }
    
    // MARK: - Initializers
    init(rectangleSize: CGSize, cornerRadius: CGFloat, rectangleColor: UIColor, strokeColor: UIColor, text: String, textColor: UIColor, fontSize: CGFloat) {
        super.init()
        
        // Rectangle setup
        rectangle = SKShapeNode(rectOf: rectangleSize, cornerRadius: cornerRadius)
        rectangle.fillColor = rectangleColor
        rectangle.strokeColor = strokeColor
        addChild(rectangle)
        
        // Label setup
        label = SKLabelNode(fontNamed: "Hardpixel")
        label.text = text
        label.fontColor = textColor
        label.fontSize = fontSize
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = rectangleSize.width - 6
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
        
        isUserInteractionEnabled = true
    }
    
    init(imageNamed: String, size: CGSize) {
        super.init()
        spriteNode = SKSpriteNode(imageNamed: imageNamed)
        spriteNode.size = size
        addChild(spriteNode)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isInside = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = self.parent {
            isInside = self.contains(touch.location(in: parent))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isInside {
            isInside = false
            if let act = action {
                act()
            }
        }
    }
    
}

extension MyButton {
    
    private func updateBtn() {
        var alpha: CGFloat = 1.0
        if isInside {
            alpha = 0.7
        }
        
        self.run(.fadeAlpha(to: alpha, duration: 0.1))
    }
}
