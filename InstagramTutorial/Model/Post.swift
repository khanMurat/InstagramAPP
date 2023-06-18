//
//  Post.swift
//  InstagramTutorial
//
//  Created by Murat on 9.06.2023.
//

import UIKit

struct Post {
    let caption : String
    var likes : Int
    let imageURL : String
    let ownerUid : String
    let timestamp : Date
    let postID: String
    let ownerImageURL : String
    let ownerUsername: String
    var didLike = false
    
    init(dictionary : [String:Any],postID:String) {
        self.postID = postID
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Date ?? Date.distantPast
        self.ownerImageURL = dictionary["ownerImageURL"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
    
}
