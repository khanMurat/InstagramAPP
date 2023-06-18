//
//  PostService.swift
//  InstagramTutorial
//
//  Created by Murat on 9.06.2023.
//

import UIKit
import FirebaseAuth


struct PostService {
    
    static func uploadPost(caption:String,image:UIImage,user:User,completion : @escaping(FireStoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        ImageUploader.uploadImage(image: image) { imageURL in
            
            let data = ["caption":caption,
                        "timestamp":Date.now,
                        "likes":0,
                        "imageURL":imageURL,
                        "ownerUid":uid,
                        "ownerImageURL":user.profileImageURL,
                        "ownerUsername":user.username] as [String:Any]
            
            COLLECTION_POSTS.addDocument(data: data,completion: completion)
        }
    }
    
    static func fetchPost(completion : @escaping ([Post]?)->Void){
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
        
            if let error = error {
                print("ERROR")
                return
            }
            
            let posts = documents.map({Post(dictionary: $0.data(), postID: $0.documentID)})
            
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid : String,completion : @escaping([Post])->Void){
        
        let query = COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var posts = documents.map({Post(dictionary: $0.data(), postID: $0.documentID)})
            
            posts.sort { post1, post2 in
                return post1.timestamp > post2.timestamp
            }
            
            completion(posts)
        }
    }
    
    static func getPost(withsPostId postId : String,completion: @escaping(Post)->Void){
        
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let post = Post(dictionary: data, postID: snapshot.documentID)
            completion(post)
        }
    }
    
    static func getLikeUsers(post:Post,completion:@escaping([String])->Void){
        
        var documentID = [String]()
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").getDocuments { snapshot, _ in
            
            guard let snapshot = snapshot else {return}
            
            let documents = snapshot.documents
            
            for document in documents {
                
                let data = document.documentID
                
                documentID.append(data)

            }
            completion(documentID)
        }
        
    }
    
    static func likePost(post:Post,completion:@escaping (FireStoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes": post.likes+1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).setData([:]) { error in
            
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).setData([:],completion: completion)
        }
    }
    
    static func unlikePost(post:Post,completion:@escaping (FireStoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard post.likes > 0 else {return}
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes":post.likes-1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).delete { _ in
            
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).delete(completion: completion)
            
        }
    }
    
    static func checkIfUserLikedPost(post:Post,completion:@escaping (Bool)->Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).getDocument { snapshot, _ in
            
            guard let didlike = snapshot?.exists else {return}
            
            completion(didlike)
        }
        
    }
}
