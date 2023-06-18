//
//  UITextView.swift
//  InstagramTutorial
//
//  Created by Murat on 8.06.2023.
//

import UIKit

class InputTextView : UITextView {
    
    //MARK: - Properties
    
    var placeholderText : String? {
        didSet{placeholderLabel.text = placeholderText}
    }
    
    let placeholderLabel : UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeHolderShoulCenter = true {
        didSet{
            if placeHolderShoulCenter {
                placeholderLabel.anchor(left: leftAnchor,right: rightAnchor,paddingLeft: 8)
                placeholderLabel.centerY(inView: self)
            }else{
                placeholderLabel.anchor(top: topAnchor,left: leftAnchor,paddingTop: 6,paddingLeft: 8)
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor,left: leftAnchor,paddingTop: 6,paddingLeft: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    
    //MARK: - Actions
    
    @objc func handleTextDidChange(){
        
        placeholderLabel.isHidden = !text.isEmpty
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
