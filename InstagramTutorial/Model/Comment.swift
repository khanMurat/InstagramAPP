//
//  Comment.swift
//  InstagramTutorial
//
//  Created by Murat on 11.06.2023.
//

import Foundation

struct Comment{
    
    let comment : String
    let profileImageURL : String
    let timestamp : Date
    let uid : String
    let username : String
    
    init(dictionary : [String:Any]) {
        self.comment = dictionary["comment"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Date ?? Date.distantPast
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
    
}
