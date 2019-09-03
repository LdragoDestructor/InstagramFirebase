//
//  UserInfo.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 15/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import Foundation

struct  UserInfo {
    let uid:String
    let username:String
    let photo_url:String
    
    init(uid:String,dict:[String:Any]){
        self.uid = uid
        self.username = dict["username"] as? String ?? ""
        self.photo_url = dict["photo_url"] as? String ?? ""
    }
}
