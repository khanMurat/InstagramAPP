//
//  CommentViewModel.swift
//  InstagramTutorial
//
//  Created by Murat on 11.06.2023.
//

import UIKit

struct CommentViewModel {
    
    var comment : Comment
    
    var commentText : NSAttributedString {
        return attributedText(username: comment.username, text: comment.comment)
    }
    
    var profileImageURL : URL? {
        return URL(string: comment.profileImageURL)
    }
    
    var timestamp : Date {
        return comment.timestamp
    }
    
    var uid : String {
        return comment.uid
    }
    
    var username : String {
        return comment.username
    }
    
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func attributedText(username:String,text:String) -> NSAttributedString {
       
       let attributedText = NSMutableAttributedString(string: "\(username): ",attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
       
       attributedText.append(NSAttributedString(string: text,attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.black]))
       
       return attributedText
   }
    
    func size(forWidth width : CGFloat) -> CGSize {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.comment
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
