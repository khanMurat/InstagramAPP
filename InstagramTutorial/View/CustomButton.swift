//
//  CustomButton.swift
//  InstagramTutorial
//
//  Created by Murat on 17.06.2023.
//

import UIKit

class CustomButton : UIButton {
    
    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    
     init(title:String) {
        super.init(frame: .zero)
        setTitle("\(title)", for: .normal)
        tintColor = .white
        backgroundColor = .darkGray
        layer.cornerRadius = 5
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        isEnabled = false
        setHeight(50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
