//
//  CustomTextFieldButton.swift
//  InstagramTutorial
//
//  Created by Murat on 1.05.2023.
//

import UIKit

class CustomTextFieldButton : UIButton {
    
    init(systemname:String) {
         super.init(frame: .zero)
        
        setDimensions(height: 40, width: 40)
        setImage(UIImage(systemName: systemname), for: .normal)
        tintColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
