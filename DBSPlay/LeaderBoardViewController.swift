//
//  LeaderBoardViewController.swift
//  DBSPlay
//
//  Created by DevilStiffer on 31/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController {
    @IBOutlet private weak var label1: UILabel!
    @IBOutlet private weak var label2: UILabel!
    @IBOutlet private weak var label3: UILabel!
    @IBOutlet var imageViews: [UIImageView]!
    
    let users = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LeaderBoard"
        // Do any additional setup after loading the view.
        setupLabelValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDBSNumber()
    }
    
    func setupLabelValues() {
        let randomInt = UserPrefrences.shared.dbsNumber //Int.random(in: 0..<1000)
        let randomString = "\(randomInt)"
        var i = 1
        for value in randomString {
            switch i {
            case 1:
                label1.text = String(value)
            case 2:
                label2.text = String(value)
            case 3:
                label3.text = String(value)
            default:
                break
            }
            i += 1
        }
    }
    
    func setupDBSNumber() {
        if UserPrefrences.shared.isGameOver {
            for item in imageViews {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    item.isHidden = true
                }
            }
        }
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
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension LeaderBoardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? users.getWinnerCount() : users.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardcell", for: indexPath) as! LeaderBoardTableViewCell
        if indexPath.section == 0 {
            if let user = users.getWinnerUser(index: indexPath.row) {
                cell.configureCell(user: user)
            }
        } else {
            if let user = users.getUser(index: indexPath.row) {
                cell.configureCell(user: user)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? UserPrefrences.shared.isGameOver ? "Winners" : "My Score" : "Others"
    }
    
}
