//
//  Extension.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 26/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    
    static  func fetchUserWithUid(uid:String,completion:@escaping (UserInfo?,Error?)->()) {
        
        Database.database().reference().child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String:Any] else {return}
            let user = UserInfo(uid:uid,dict: value)
            completion(user,nil)
            
        }) { (error) in
            completion(nil,error)
            print("Failed to fetch data",error)
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}
