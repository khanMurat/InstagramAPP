//
//  PostViewModel.swift
//  InstagramTutorial
//
//  Created by Murat on 9.06.2023.
//

import UIKit

struct PostViewModel {
    
    var post : Post
    
    var imageURL : URL? {
        return URL(string: post.imageURL)
    }
    
    var caption : String {
        return post.caption
    }
    
    var likes : String {
        
        if post.likes != 1 {
            return "\(post.likes) likes"
        }else{
            return "\(post.likes) like"
        }
        
    }
    
    var likeButtonTintColor : UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage : UIImage? {
        return post.didLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    var timestamp : Date {
        return post.timestamp
    }
    
    var userImageURL: URL? {
        return URL(string: post.ownerImageURL)
    }
    var username : String {
        return post.ownerUsername
    }
    
    init(post:Post){
        self.post = post
    }
    
}
