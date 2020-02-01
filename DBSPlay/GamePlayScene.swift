//
//  GamePlayScene.swift
//  DBSPlay
//
//  Created by DevilStiffer on 30/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit
import SpriteKit

let ballCategoryName:String! = "ball"
let paddleCategoryName:String! = "paddle"
let blockCategoryName:String! = "block"
let blockNodeCategoryName:String! = "blockNode"

let ballCategory:UInt32 = 0x1 << 0  // 00000000000000000000000000000001
let bottomCategory:UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let blockCategory:UInt32 = 0x1 << 2  // 00000000000000000000000000000100
let paddleCategory:UInt32 = 0x1 << 3 // 00000000000000000000000000001000


class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    private var isFingerOnPaddle:Bool = false
    
    init(size:CGSize, fromRetry: Bool = false) {
        super.init(size:size)
        if fromRetry {
            self.initialize()
        } else {
            showGameWaitingMessage()
        }
    }
    
    fileprivate func showGameWaitingMessage() {
        var nofCount = 3
        let waitingLabel = SKLabelNode(fontNamed: "Arial")
        waitingLabel.fontSize = 84
        waitingLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        waitingLabel.text = "\(nofCount)"
        waitingLabel.numberOfLines = 0
        self.addChild(waitingLabel)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
            if nofCount == 1 {
                waitingLabel.removeFromParent()
                timer.invalidate()
                self?.initialize()
            } else {
                nofCount -= 1
                waitingLabel.text = "\(nofCount)"
            }
        }
    }
    
    private func initialize() {
        let background:SKSpriteNode! = SKSpriteNode(imageNamed: "bg1")
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addChild(background)
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        // 1 Create an physics body that borders the screen
        let borderBody:SKPhysicsBody! = SKPhysicsBody(edgeLoopFrom: self.frame)
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        // 3 Set the friction of that physicsBody to 0
        self.physicsBody?.friction = 0.0
        
        // 1
        let ball:SKSpriteNode! = SKSpriteNode(imageNamed: "ball1.png")
        ball.name = ballCategoryName
        ball.position = CGPoint(x: self.frame.size.width/3, y: self.frame.size.height/3)
        self.addChild(ball)
        
        // 2
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        // 3
        ball.physicsBody?.friction = 0.0
        // 4
        ball.physicsBody?.restitution = 1.0
        // 5
        ball.physicsBody?.linearDamping = 0.0
        // 6
        ball.physicsBody?.allowsRotation = false
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 10.0, dy: -10.0))
        
        let paddle:SKSpriteNode! = SKSpriteNode(imageNamed:"paddle1.png")
        paddle.name = paddleCategoryName
        paddle.position = CGPoint(x: self.frame.midX, y: paddle.frame.size.height * 0.6)
        self.addChild(paddle)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.friction = 0.4
        // make physicsBody static
        paddle.physicsBody?.isDynamic = false
        
        let bottomRect:CGRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1)
        let bottom:SKNode! = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        self.addChild(bottom)

        bottom.physicsBody?.categoryBitMask = bottomCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        paddle.physicsBody?.categoryBitMask = paddleCategory
        
        ball.physicsBody?.contactTestBitMask = bottomCategory | blockCategory
        
        self.physicsWorld.contactDelegate = self
        
        // 1 Store some useful variables
        let numberOfBlocks:Int = 3
        let blockWidth:Int = Int(SKSpriteNode(imageNamed: "block.png").size.width)
        let padding:Int = 20
        // 2 Calculate the xOffset
        let bWidth = CGFloat(blockWidth * numberOfBlocks + padding * (numberOfBlocks-1))
        let xOffset = (self.frame.size.width - bWidth) / 2
        // 3 Create the blocks and add them to the scene
        var score: String = ""
        for i in 1...numberOfBlocks {
            let block = SKSpriteNode(imageNamed: "block.png")
            let numberLabel = SKLabelNode(fontNamed: "Arial")
            numberLabel.name = "Number"
            numberLabel.fontSize = 42
            numberLabel.position = CGPoint(x: block.frame.midX, y: block.frame.midY)
            let randomInt = Int.random(in: 0..<10)
            score += "\(randomInt)"
            numberLabel.text = "\(randomInt)"
            numberLabel.isHidden = true
            block.addChild(numberLabel)
            let a = (CGFloat(i) - 0.5) * block.frame.size.width
            let b = (i - 1) * padding
            let x = a + CGFloat(b) + xOffset
            block.position = CGPoint(x: x, y: self.frame.size.height * 0.8)
            block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
            block.physicsBody?.allowsRotation = false
            block.physicsBody?.friction = 0.0
            block.name = blockCategoryName
            block.physicsBody?.categoryBitMask = blockCategory
            self.addChild(block)
        }
        UserPrefrences.shared.setScore(score: Int(score) ?? 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let touchLocation:CGPoint = touch.location(in: self)
            
            let body:SKPhysicsBody! = self.physicsWorld.body(at: touchLocation)
            if (body != nil) && (body.node?.name == paddleCategoryName) {
                NSLog("Began touch on paddle")
                self.isFingerOnPaddle = true
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isFingerOnPaddle, let touch = touches.first as UITouch? {
            // 2 Get touch location
            let touchLocation:CGPoint = touch.location(in: self)
            let previousLocation:CGPoint = touch.previousLocation(in: self)
            // 3 Get node for paddle
            let paddle:SKSpriteNode! = self.childNode(withName: paddleCategoryName) as? SKSpriteNode
            // 4 Calculate new position along x for paddle
            var paddleX:Int = Int(paddle.position.x + (touchLocation.x - previousLocation.x))
            // 5 Limit x so that the paddle will not leave the screen to left or right
            paddleX = max(paddleX, Int(paddle.size.width/2))
            paddleX = min(paddleX, Int(self.size.width - paddle.size.width/2))
            // 6 Update position of paddle
            paddle.position = CGPoint(x: CGFloat(paddleX), y: paddle.position.y)
        }
        super.touchesMoved(touches, with: event)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isFingerOnPaddle = false
        super.touchesEnded(touches, with: event)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1 Create local variables for two physics bodies
        var firstBody:SKPhysicsBody!
        var secondBody:SKPhysicsBody!
        // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // 3 react to the contact between ball and bottom
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory {
            let gameOverScene = GameOverScene(size:self.frame.size, isNumberGenerated:false)
            self.view?.presentScene(gameOverScene)
        }
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == blockCategory {
//            secondBody.node?.removeFromParent()
            secondBody.node?.childNode(withName: "Number")?.isHidden = false
            if self.isGameWon() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let gameWonScene = GameOverScene(size: self.frame.size, isNumberGenerated:true)
                    self.view?.presentScene(gameWonScene)
                }
            }
        }
    }
    
    func isGameWon() -> Bool {
        var numberOfBricks:Int = 0
        for element in self.children where element.childNode(withName: "Number")?.isHidden == true {
            if let node = element as SKNode?, node.name?.isEqual(blockCategoryName) ?? false {
                numberOfBricks += 1
            }
        }
        return numberOfBricks <= 0
    }
    
    func update(currentTime:CFTimeInterval) {
        /* Called before each frame is rendered */
        let ball:SKNode! = self.childNode(withName: ballCategoryName)
        let maxSpeed:Int = 1000
        let dx2 = ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx
        let dy2 = ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy
        let speed:CGFloat = sqrt(dx2 + dy2)
        if Int(speed) > maxSpeed {
            ball.physicsBody?.linearDamping = 0.4
        } else {
            ball.physicsBody?.linearDamping = 0.0
        }
    }
}
