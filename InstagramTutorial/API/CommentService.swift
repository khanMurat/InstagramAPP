//
//  CommentService.swift
//  InstagramTutorial
//
//  Created by Murat on 11.06.2023.
//

import Foundation

struct CommentService {
    
    static func uploadComment(comment:String,postID:String,user:User,completion : @escaping(FireStoreCompletion)){
        
        let data : [String:Any] = ["uid":user.uid,
                                   "comment":comment,
                                   "timestamp":Date(),
                                   "username":user.username,
                                   "profileImageURL":user.profileImageURL]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data,
                                                                             completion: completion)
        
        
    }
    
    static func fethComments(postID:String,completion: @escaping([Comment]?)->Void){
        
        var comments = [Comment]()
        
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp",descending: true)
        
        query.addSnapshotListener { snapshot, error in
            
            snapshot?.documentChanges.forEach({ change in
                
                if change.type == .added {
                    
                    let data = change.document.data()
                    
                    let comment = Comment(dictionary: data)
                    
                    comments.append(comment)
                    
                   // comments.sort { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970}
                }
                completion(comments)
            })
        }
//        COLLECTION_POSTS.document(postID).collection("comments").getDocuments { snapshot, error in
//
//            if error == nil {
//
//                guard let documents = snapshot?.documents else {return}
//
//                var comments = documents.map({Comment(dictionary: $0.data())})
//
//                completion(comments)
//            }
//        }
    }
    
}
