//
//  GameViewController.swift
//  DBSPlay
//
//  Created by DevilStiffer on 30/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    @IBOutlet private weak var gameView: SKView!
    @IBOutlet private weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        intializeGameView()
        setContinueButtonSelection(enable: false)
        if let img = UIImage(named: "bg1") {
            self.view.backgroundColor = UIColor(patternImage: img)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserPrefrences.shared.gameController = self
        navigationController?.setNavigationBarHidden(true, animated: animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        //        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserPrefrences.shared.gameController = nil
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func intializeGameView() {
        if !(gameView.scene != nil) {
            gameView.showsFPS = true
            gameView.showsNodeCount = true
            
            // Create and configure the scene.
            let scene:SKScene! = GamePlayScene(size: gameView.bounds.size)
            scene.scaleMode = .aspectFit
            
            // Present the scene.
            gameView.presentScene(scene)
        }
    }
    
    func setContinueButtonSelection(enable: Bool) {
        continueButton.isUserInteractionEnabled = enable
    }
    
    @IBAction func gotoLeaderBoardAction(_ sender: Any) {
        self.performSegue(withIdentifier: "gameToLeaderBoardSegue", sender: sender)
    }
}

