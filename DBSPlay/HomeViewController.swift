//
//  HomeViewController.swift
//  DBSPlay
//
//  Created by DevilStiffer on 31/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet private weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Play & Win"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playNowAction(_ sender: Any) {
        displayNameTextField.resignFirstResponder()
        let displayName = displayNameTextField.text ?? "anonymous"
        UserPrefrences.shared.setDisplayName(name: displayName)
        self.performSegue(withIdentifier: "homeToGameSegue", sender: sender)
//        login()
    }
    
    
    func login() {
        Auth.auth().signInAnonymously { (user, error) in
            guard let user = user?.user else { return }
            let uid = user.uid
            UserPrefrences.shared.setUserID(id: uid)
        }
    }
}
