//
//  NotificationService.swift
//  InstagramTutorial
//
//  Created by Murat on 14.06.2023.
//

import FirebaseAuth
import FirebaseFirestore

struct NotificationService {
    
    static func uploadNotification(toUid uid:String,fromUser:User,type:NotificationType,post:Post? = nil){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard uid != currentUid else {return}
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data : [String:Any] = ["timestamp":Timestamp(date: Date()),
                                   "uid":fromUser.uid,
                                   "type":type.rawValue,
                                   "id":docRef.documentID,
                                   "userProfileImageUrl":fromUser.profileImageURL,
                                   "username":fromUser.username]
        
        if let post = post {
            data["postId"] = post.postID
            data["postImageUrl"] = post.imageURL
        }
       
        docRef.setData(data)
        
    }
    
    static func fetchNotifications(completion : @escaping ([Notification]) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            if let error = error {
                print("error\(error.localizedDescription)")
                return
            }
            
            let notifications = documents.map({Notification(dictionary: $0.data())})
            
            completion(notifications)
        }
    }
}
