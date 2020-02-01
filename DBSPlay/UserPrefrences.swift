//
//  UserPrefrences.swift
//  DBSPlay
//
//  Created by DevilStiffer on 31/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import Foundation

class UserPrefrences {
    static let shared = UserPrefrences()
    private var displayName: String = ""
    private var userID: String = ""
    private var score = 0
    var dbsNumber: Int = 924
    var isGameOver = true
    weak var gameController: GameViewController?
    
    func setDisplayName(name: String) {
        displayName = name
    }
    
    func getDisplayName() -> String {
        return displayName
    }
    
    func setUserID(id: String) {
        userID = id
    }
    
    func getUserID() -> String {
        return userID
    }
    
    func setScore(score: Int) {
        self.score = score
    }
    
    func getScore() -> Int {
        return self.score
    }
}
