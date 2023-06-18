//
//  ProfileController.swift
//  InstagramTutorial
//
//  Created by Murat on 27.04.2023.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController : UICollectionViewController {
    
    //MARK: - Properties
    
    private var user : User
    
    private var posts = [Post]()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        checkIsUserFollowed()
        userStats()
        fetchPosts()
    }
    
    //MARK: - API
    
    func checkIsUserFollowed(){
        UserService.checkIfUserFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func userStats(){
        UserService.getUserStats(uid: user.uid) { stats in
            self.user.userStats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts(){
        PostService.fetchPosts(forUser: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureCollectionView(){
        self.collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = .systemBackground
       
        self.navigationItem.title = user.username
    }
    
}
//MARK: - UICollectionViewDataSource

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
            header.delegate = self
            header.viewModel = ProfileHeaderViewModel(user: user)
        
        return header
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 2)/3
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let post = posts[indexPath.row]
        controller.post = post
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - SectionHeadProfileHeaderDelegate

extension ProfileController : ProfileHeaderDelegate {
    
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        
        guard let tab = tabBarController as? MainTabController else {return}
        guard let currenUser = tab.user else {return}
        
            if user.isCurrentUser {
                print("Edit profile button handle")
            } else if user.isFollowed{
                
                UserService.unfollow(uid: user.uid) { error in
                    if let error = error {
                        self.showMessage(withTitle: error.localizedDescription, message: error.localizedDescription)
                    }
                    self.user.isFollowed = false
                    self.userStats()
                }
               
            }else{
                UserService.follow(uid: user.uid) { error in
            
                    if let error = error {
                        self.showMessage(withTitle: error.localizedDescription, message: error.localizedDescription)
                        return
                    }
                    self.user.isFollowed = true
                    self.userStats()
                    
                    NotificationService.uploadNotification(toUid: user.uid,
                                                           fromUser: currenUser,
                                                           type: .follow)
                    
            }
        }
    }
}
