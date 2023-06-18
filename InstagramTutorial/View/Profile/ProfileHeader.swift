//
//  ProfileHeader.swift
//  InstagramTutorial
//
//  Created by Murat on 4.06.2023.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate : AnyObject {
    func header(_ profileHeader:ProfileHeader,didTapActionButtonFor user : User)
}

class ProfileHeader : UICollectionReusableView {
    
    //MARK: - Properties
    
    var viewModel : ProfileHeaderViewModel? {
        didSet{configure()}
    }
    
    weak var delegate : ProfileHeaderDelegate?
    
    private let userImage : UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 80 / 2
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let fullName : UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private lazy var editButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Loading", for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        return btn
    }()
    
    private lazy var postLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        return button
    }()
    
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SelectorFuncs
    
    @objc func handleEditProfile(){
        
        guard let user = viewModel?.user else{return}
        
        delegate?.header(self, didTapActionButtonFor: user)
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        
        addSubview(userImage)
        userImage.anchor(top: topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 12)
        userImage.setDimensions(height: 80, width: 80)
        
        addSubview(fullName)
        fullName.anchor(top: userImage.bottomAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 12)
        
        addSubview(editButton)
        editButton.anchor(top: fullName.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 24,paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerY(inView: userImage)
        stack.anchor(left:userImage.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12,height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor,right: rightAnchor,height: 50)
        
        addSubview(topDivider)
        topDivider.anchor(top: buttonStack.topAnchor,left: leftAnchor,right: rightAnchor,height: 0.5)
        
        addSubview(bottomDivider)
        bottomDivider.anchor(left: leftAnchor,bottom: buttonStack.bottomAnchor,right: rightAnchor,height: 0.5)
        
    }
    
    func configure(){
        
        guard let viewModel = viewModel else {return}
        
        fullName.text = viewModel.fullname

        userImage.sd_setImage(with: viewModel.profileImageURL)
        
        editButton.setTitle(viewModel.followButtonText, for: .normal)
        editButton.backgroundColor = viewModel.followButtonColor
        editButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        
        followingLabel.attributedText = viewModel.numberOfFollowing
        followersLabel.attributedText = viewModel.numberOfFollowers
        postLabel.attributedText = viewModel.numberOfPosts
        
    }
    
}
