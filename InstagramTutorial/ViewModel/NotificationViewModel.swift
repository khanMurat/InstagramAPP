//
//  NotificationViewModel.swift
//  InstagramTutorial
//
//  Created by Murat on 14.06.2023.
//

import UIKit

struct NotificationViewModel {
    var notification : Notification
    
    var postImageUrl : URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    
    var profileImageUrl : URL? {
        return URL(string: notification.userProfileImageUrl)
    }
    
    var timestampString : String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second , .minute , .hour , .day , .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date()) ?? "1m"
    }
    
    var notificationMessage : NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username,attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message,attributes: [.font:UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " \(timestampString!)",attributes: [.foregroundColor:UIColor.lightGray]))
        
     return attributedText
    }
    
    var followButtonText : String {return notification.userIsFollowed ? "Following":"Follow"}
    
    var followButtonBackgroundColor : UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
    }
    
    var followButtonTintColor : UIColor {
        return notification.userIsFollowed ? .black : .white
    }
    
    var shouldHidePostImage : Bool {
        return notification.type == .follow
    }
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    
}
