//
//  Notification.swift
//  InstagramTutorial
//
//  Created by Murat on 14.06.2023.
//

import UIKit
import FirebaseFirestore

enum NotificationType : Int {
    case like
    case follow
    case comment
    
    var notificationMessage : String {
        switch self {
        case .like : return " liked your post"
        case .follow : return " following you"
        case .comment : return " commented on your post"
        }
    }
}

struct Notification {
    
    let uid : String
    var postImageUrl : String?
    var postId : String?
    let timestamp : Timestamp
    let type : NotificationType
    let id : String
    let userProfileImageUrl : String
    let username : String
    var userIsFollowed = false
    
    init(dictionary : [String:Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.id = dictionary["id"] as? String ?? ""
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
