//
//  ProfileHeaderViewModel.swift
//  InstagramTutorial
//
//  Created by Murat on 5.06.2023.
//

import UIKit

struct ProfileHeaderViewModel {
    
    let user : User
    
    var fullname : String {
        return user.fullname
    }
    var profileImageURL : URL {
        return URL(string: user.profileImageURL)!
    }
    
    var userStats : UserStats {
        return user.userStats
    }
    
    var numberOfPosts : NSAttributedString {
        
        return attributedStatText(value: user.userStats.posts, label: "posts")
    }
    
    var numberOfFollowers : NSAttributedString {
        
        return attributedStatText(value: user.userStats.followers, label: "followers")
    }
    
    var numberOfFollowing : NSAttributedString {
        
        return attributedStatText(value: user.userStats.following, label: "following")
    }
    
    
    var followButtonText : String {
        
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
        
    }
    
    var followButtonColor : UIColor {
        
        if user.isCurrentUser {
            return UIColor.white
        }
        
        return user.isFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor : UIColor {
        
        if user.isCurrentUser {
            return UIColor.black
        }
        
        return user.isFollowed ? .black : .white
    }
    
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStatText(value:Int,label:String) -> NSAttributedString {
       
       let attributedText = NSMutableAttributedString(string: "\(value)\n",attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
       
       attributedText.append(NSAttributedString(string: label,attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
       
       return attributedText
   }
    
}
