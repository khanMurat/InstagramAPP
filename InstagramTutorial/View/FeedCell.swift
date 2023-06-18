//
//  FeedCell.swift
//  InstagramTutorial
//
//  Created by Murat on 27.04.2023.
//

import UIKit

protocol FeedCellDelegate : AnyObject{
    
    func cell(_ cell : FeedCell,wantsToShowCommentsFor post : Post)
    func cell(_ cell : FeedCell,didLike post: Post)
    func cell(_ cell : FeedCell,showLike post:Post)
    func cell(_ cell : FeedCell,wantsToShowProfileFor uid:String)
}

class FeedCell : UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate : FeedCellDelegate?
    
    var viewModel : PostViewModel? {
        didSet {configure()}
    }
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var usernameButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("venom", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .systemBackground
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    private let postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
     lazy var likeButton : UIButton = {
      
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton : UIButton = {
      
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleNavigateComment), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton : UIButton = {
      
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var likesLabelButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        return btn
    }()
    
    private let captionLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let postTimeLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likesLabelButton)
        likesLabelButton.anchor(top: likeButton.bottomAnchor,left: leftAnchor,paddingTop: -4,paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabelButton.bottomAnchor,left: leftAnchor,paddingTop: 4,paddingLeft: 8)
        
//        addSubview(postTimeLabel)
//        postTimeLabel.anchor(top: captionLabel.bottomAnchor,left: leftAnchor,paddingTop: 4,paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func showUserProfile(){
        guard let viewModel = viewModel else {return}
        
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)
    }
    
    @objc func handleNavigateComment(){
        
        guard let viewModel = viewModel else {return}
        
        delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    @objc func didTapLike(){
        
        guard let viewModel = viewModel else {return}
        
        delegate?.cell(self, didLike: viewModel.post)
    }
    
    @objc func handleShowLikes(){
        
        guard let viewModel = viewModel else {return}
        
        delegate?.cell(self, showLike: viewModel.post)
        
    }
    
    //MARK: - Helpers
    
    func configure(){
        
        guard let viewModel = viewModel else {return}
        
        captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageURL)
        postTimeLabel.text = String(viewModel.timestamp.formatted())
        likesLabelButton.setTitle(viewModel.likes, for: .normal)
        
        
        usernameButton.setTitle(viewModel.username, for: .normal)
        profileImageView.sd_setImage(with: viewModel.userImageURL)
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)

    }
    
    func configureActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor,left: leftAnchor,width: 120,height: 50)
        
    }
    
}
