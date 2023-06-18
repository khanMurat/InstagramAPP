//
//  LikeViewModel.swift
//  InstagramTutorial
//
//  Created by Murat on 13.06.2023.
//

import Foundation


struct LikeViewModel {
    
    var user : User
    
    var username : String {
        
        return user.username
    }
    
    var profileImageURL : URL? {
        
        return URL(string: user.profileImageURL)
    }
    
    
    init(user: User) {
        self.user = user
    }
}
