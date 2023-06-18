//
//  ProfileCell.swift
//  InstagramTutorial
//
//  Created by Murat on 4.06.2023.
//

import UIKit


class ProfileCell : UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel : PostViewModel? {
        didSet{configure()}
    }
    
    private let userImages : UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
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
    
    //MARK: - Helpers
    
    func configureUI(){
        
        addSubview(userImages)
        userImages.fillSuperview()
        
    }
    
    func configure(){
        
        guard let viewModel = viewModel else {return}
        
        userImages.sd_setImage(with: viewModel.imageURL)

    }
}
