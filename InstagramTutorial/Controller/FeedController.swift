//
//  FeedController.swift
//  InstagramTutorial
//
//  Created by Murat on 27.04.2023.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class FeedController : UICollectionViewController {
    
    //MARK: - Properties
    
    private var posts = [Post](){
        didSet{collectionView.reloadData()}
    }
    
    var currentUser : User?
    
    var post : Post? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        if post != nil {
            self.checkIfUserLikedPost()
        }
        
        fetchPosts {
            self.checkIfUserLikedPost()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        }
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        posts.removeAll()
        self.fetchPosts {
        }
    }
    
    @objc func handleLogOut(){
        
        showMessageYesAndCancel(withTitle: "Are you sure to quit?", message: "", vc: LoginController())
        
    }
    
    //MARK: - API
    
    func fetchPosts(completion: @escaping () -> Void) {
        PostService.fetchPost { posts in
            self.posts = posts ?? []
            self.collectionView.refreshControl?.endRefreshing()
            completion()
        }
    }
    
    func checkIfUserLikedPost(){
        if let post = post {
            PostService.checkIfUserLikedPost(post: post) { didLike in
                self.post?.didLike = didLike
            }
        }else{
            self.posts.forEach { post in
                PostService.checkIfUserLikedPost(post: post) { didLike in
                    if let index = self.posts.firstIndex(where: {$0.postID == post.postID}){
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post != nil ? 1 : posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.delegate = self
                
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        
        }else{
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        var height = width + 8 + 40 + 8
        
        height += 110
        
        return CGSize(width: width, height: height)
    }
    
}

extension FeedController : FeedCellDelegate {
    
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        
        let controller = CommentController(post: post)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, showLike post: Post) {
        let group = DispatchGroup()
        var users = [User]()

        PostService.getLikeUsers(post: post) { documents in
            for document in documents {
                group.enter()
                
                UserService.fetchUser(withUid: document) { user in
                    users.append(user)
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                let controller = LikeController()
                controller.likesUsers = users
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    func cell(_ cell: FeedCell, didLike post: Post) {
        
        
        guard let tab = tabBarController as? MainTabController else {return}
        guard let user = tab.user else {return}
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            
            PostService.unlikePost(post: post) { error in
                if let error = error{
                    self.showMessage(withTitle: "We could not complete", message: error.localizedDescription)
                    return
                }
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
            
        }else{
            PostService.likePost(post: post) { error in
                
                if let error = error{
                    self.showMessage(withTitle: "We could not complete", message: error.localizedDescription)
                    return
                }
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user,type: .like,post: post)
            }
        }
    }
    
}
