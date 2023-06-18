//
//  AuthenticationViewModel.swift
//  InstagramTutorial
//
//  Created by Murat on 2.05.2023.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var isValid : Bool {get}
    var buttonBackgroundColor : UIColor {get}
}

struct LoginViewModel : AuthenticationViewModel {
    
    var email : String?
    var password : String?
    
    var isValid : Bool {
        
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor : UIColor {
        if isValid{
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
}

struct RegistrationViewModel : AuthenticationViewModel {
    var email : String?
    var password : String?
    var fullname : String?
    var username : String?
    
    var isValid : Bool {
        
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor : UIColor {
        if isValid{
            return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        }else{
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
    }
}

struct ResetPasswordViewModel : AuthenticationViewModel {
    
    var email : String?
    
    var isValid: Bool {
        return email?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        if isValid{
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    
}
    
    
