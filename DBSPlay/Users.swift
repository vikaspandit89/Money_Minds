//
//  Users.swift
//  DBSPlay
//
//  Created by DevilStiffer on 31/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit

struct User: Equatable {
    var name = ""
    var score = ""
    var isMyself = false
    var isWinner = false
    var rating = 1
    

    init(name: String, score: String, isMe: Bool = false, isWinner: Bool = false) {
        self.name = name
        self.score = score
        self.isMyself = isMe
        self.isWinner = isWinner
        self.rating = Int.random(in: 1..<6)
    }
}

struct Users {
    private var allUsersList = [User]()
    var winnerList = [User]()
    var usersList = [User]()
    init() {
        addMySelf()
        for i in 1...1000 {
            let name = "ananymous \(i)"
            let randomInt = Int.random(in: 1..<1000)
            let user = User(name: name, score: "\(randomInt)")
            self.allUsersList.append(user)
        }
        if UserPrefrences.shared.isGameOver {
            setAllWinners()
        }
        self.usersList = getUsers()
        self.winnerList = getWinners()
    }
    
    mutating func addMySelf() {
        let name = UserPrefrences.shared.getDisplayName()
        let score = UserPrefrences.shared.getScore()
        let user = User(name: name, score: "\(score)", isMe: true)
        self.allUsersList.append(user)
    }
    
    func getCount() -> Int {
        return self.usersList.count
    }
    
    func getUser(index: Int) -> User? {
        if index > getCount() {
            return nil
        }
        return self.usersList[index]
    }
    
    func getWinnerCount() -> Int {
        return self.winnerList.count
    }
    
    func getWinnerUser(index: Int) -> User? {
        if index > getWinnerCount() {
            return nil
        }
        return self.winnerList[index]
    }
    
    private func getMyself() -> [User] {
        let users = allUsersList.all(where: { $0.isMyself == true })
        return users
    }
    
    private func getWinners() -> [User] {
        if UserPrefrences.shared.isGameOver {
            let users = allUsersList.all(where: { $0.isWinner == true })
            return users
        } else {
            return getMyself()
        }
    }
    
    mutating func setAllWinners() {
        let threshold = 5
        var newUserList = [User]()
        for var user in allUsersList {
            let score = Int(user.score) ?? 0
            if score > UserPrefrences.shared.dbsNumber - threshold && score < UserPrefrences.shared.dbsNumber + threshold {
                user.isWinner = true
            }
            newUserList.append(user)
        }
        allUsersList = newUserList
    }
    
    private func getUsers() -> [User] {
        if UserPrefrences.shared.isGameOver {
            let users = allUsersList.all(where: { $0.isWinner == false && $0.isMyself == false })
            return users
        } else {
            let users = allUsersList.all(where: { $0.isMyself == false })
            return users
        }
    }
}

extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}
