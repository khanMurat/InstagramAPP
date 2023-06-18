//
//  LikeCell.swift
//  InstagramTutorial
//
//  Created by Murat on 13.06.2023.
//

import UIKit

class LikeCell : UITableViewCell {
    
    
    //MARK: - Properties
    
    var viewModel : LikeViewModel? {
        didSet{configure()}
    }
    
    private let userImageView : UIImageView = {
       
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
        
    }()
    
    private let usernameLabel : UILabel = {
       
        let label = UILabel()
        label.text = "Venom"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        
        
        addSubview(userImageView)
        
        userImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 8)
        userImageView.setDimensions(height: 50, width: 50)
        userImageView.layer.cornerRadius = 50 / 2
        
        addSubview(usernameLabel)
        
        usernameLabel.centerY(inView: userImageView,leftAnchor: userImageView.rightAnchor,paddingLeft: 8)
        
        
    }
    
    func configure(){
        
        guard let viewModel = viewModel else{return}
        
        usernameLabel.text = viewModel.username
        
        userImageView.sd_setImage(with: viewModel.profileImageURL)
        
    }
    
}
