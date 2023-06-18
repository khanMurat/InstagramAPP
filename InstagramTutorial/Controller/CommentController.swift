//
//  CommentController.swift
//  InstagramTutorial
//
//  Created by Murat on 11.06.2023.
//

import UIKit

private let identifier = "CollectionCell"

class CommentController : UICollectionViewController {
    
    //MARK: - Properties
    
    private let post : Post
    
    private lazy var comments = [Comment]()
    
    private lazy var commentInputView : CommentInputAccesoryView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView()
        cv.delegate = self
        cv.frame = frame
        return cv
        
    }()
    
    //MARK: - Lifecycle
    
    init(post:Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionUI()
        
        getComments()
    }
    
    override var inputAccessoryView: UIView? {
        
        get { return commentInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - API
    
    func getComments(){
        
        CommentService.fethComments(postID: post.postID) { comments in
            
            guard let comments = comments else {return}
            DispatchQueue.main.async {
                self.comments = comments
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureCollectionUI(){
        
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: identifier)
        
        navigationItem.title = "Comments"
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }

}
//MARK: - CollectionViewDataSource

extension CommentController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CommentCell
        
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CommentController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: 80)
    }
}

//MARK: - CommentInputAccesoryViewDelegate

extension CommentController : CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        
        guard let tab = self.tabBarController as? MainTabController else {return}
        guard let currentUser = tab.user else {return}
        
        showLoader(true)
        
                CommentService.uploadComment(comment: comment, postID: post.postID, user: currentUser) { error in
                    
                    inputView.clearCommentTextView()
                    
                    self.showLoader(false)
                    
                    NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: currentUser, type: .comment,post: self.post)
        }
    }
}

//MARK: - UICollectionViewDelegate
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let uid = comments[indexPath.row].uid
        
        UserService.fetchUser(withUid: uid) { user in
        
            let controller = ProfileController(user: user)
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}
