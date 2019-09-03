//
//  UserPost.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 21/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit


struct UserPost{
    let user:UserInfo
    let imageurl:String
    let posttext :String
    let creationDate:Date
    
    init(user:UserInfo,dict:[String:Any]){
        self.user = user
        self.imageurl = dict["imageurl"] as? String ?? ""
        self.posttext = dict["posttext"] as? String ?? ""
        
        
        
        let secondsFrom1970 = dict["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970 )
    }
}
