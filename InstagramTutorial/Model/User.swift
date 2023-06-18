//
//  User.swift
//  InstagramTutorial
//
//  Created by Murat on 5.06.2023.
//

import Foundation
import FirebaseAuth

struct User {
    
    let email : String
    let fullname:String
    let profileImageURL : String
    let username: String
    let uid : String
    
    var userStats = UserStats(followers: 0, following: 0, posts: 0)
    
    var isFollowed : Bool = false
    
    var isCurrentUser : Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    var followingNumber = 0
    
    init(dictionary: [String:Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageURL = dictionary["imageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
}

struct UserStats {
    
    var followers : Int
    
    var following : Int
    
    var posts : Int
    
}
