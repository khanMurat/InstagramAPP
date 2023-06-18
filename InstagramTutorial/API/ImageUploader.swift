//
//  ImageUploader.swift
//  InstagramTutorial
//
//  Created by Murat on 2.06.2023.
//

import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(image:UIImage,comletion : @escaping (String)->Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        
        let fileName = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/profile_Images/\(fileName)")
        
        ref.putData(imageData) { metadata, error in
            if let error = error {
                
                print(error.localizedDescription)
            }
            
            ref.downloadURL { url, error in
                
                guard let imageUrl = url?.absoluteString else {return}
                
                comletion(imageUrl)
            }
        }
        
    }
    
    
}
