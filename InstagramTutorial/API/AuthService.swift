//
//  AuthService.swift
//  InstagramTutorial
//
//  Created by Murat on 2.06.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

typealias SendResetPasswordCallback = ((Error?) -> Void)?

struct AuthCredentials {
    
    var email : String
    var password : String
    var fullname : String
    var username : String
    var profileImage : UIImage
    
}

struct AuthService {
    
    static func registerUser(with credentials : AuthCredentials,completion : @escaping (Error?) -> Void) {
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { data, error in
                if error != nil {
                    completion(error)
                    return
                } else{
                    
                    guard let uUid = data?.user.uid else{return}
                    
                    let data : [String:Any] = ["email":credentials.email,
                                               "password":credentials.password,
                                               "fullname":credentials.fullname,
                                               "username":credentials.username,
                                               "imageURL":imageURL,
                                               "uid":uUid]
                    
                    COLLECTION_USERS.document(uUid).setData(data,completion: completion)
                }
            }
        }
    }
    
    static func loginUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func resetPassword(with email : String,completion : SendResetPasswordCallback){
        Auth.auth().sendPasswordReset(withEmail: email,completion: completion)
    }
}

