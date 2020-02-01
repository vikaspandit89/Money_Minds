//
//  GameOverScene.swift
//  DBSPlay
//
//  Created by DevilStiffer on 30/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    private var isNumberGenerated = false

    init(size: CGSize, isNumberGenerated: Bool) {
        super.init(size:size)
        self.isNumberGenerated = isNumberGenerated
        let background:SKSpriteNode! = SKSpriteNode(imageNamed: "bg1")
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addChild(background)
        // 1
        let gameOverLabel:SKLabelNode! = SKLabelNode(fontNamed: "Arial")
        gameOverLabel.fontSize = 35
        gameOverLabel.numberOfLines = 0
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        let score = UserPrefrences.shared.getScore()
        gameOverLabel.text = isNumberGenerated ? "Your Number is: \(score)" : "Try Again"
        self.addChild(gameOverLabel)
        UserPrefrences.shared.gameController?.setContinueButtonSelection(enable: isNumberGenerated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isNumberGenerated {
            let breakoutGameScene = GamePlayScene(size:self.size, fromRetry: true)
            self.view?.presentScene(breakoutGameScene)
        }
        super.touchesBegan(touches, with: event)
    }

    func showLeaderBoard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LeaderBoardViewController")
        UserPrefrences.shared.gameController?.show(controller, sender: nil)
    }
}
