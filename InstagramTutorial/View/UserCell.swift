//
//  UserCell.swift
//  InstagramTutorial
//
//  Created by Murat on 6.06.2023.
//

import UIKit


class UserCell : UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel : UserCellViewModel? {
        didSet{
           configure()
        }
    }
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let usernameLabel : UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let fullnameLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        
        addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 8)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure(){
        
        guard let viewModel = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
    }
}
