//
//  NotificationsController.swift
//  InstagramTutorial
//
//  Created by Murat on 27.04.2023.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController : UITableViewController {
    
    //MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet{tableView.reloadData()}
    }
    
    private var refresher = UIRefreshControl()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       configureTableViewUI()
        fetchNotifications()
    }
    
    //MARK: - API
    
    func fetchNotifications(){
        
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
            self.tableView.reloadData()
        }
    }
    
    func checkIfUserIsFollowed(){
        notifications.forEach { notification in
            guard notification.type == .follow else{return}
            
            UserService.checkIfUserFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}){
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    
    //MARK: - Helpers
    
    func configureTableViewUI(){
        view.backgroundColor = .white
        
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    //MARK: - Actions

    @objc func handleRefresher(){
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
}

//MARK: - UITableViewDataSource
extension NotificationsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! NotificationCell
        
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        let uid = notifications[indexPath.row].uid

        UserService.fetchUser(withUid: uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

//MARK: - NotificationCellDelegate

extension NotificationsController : NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        UserService.follow(uid: uid) { error in
            cell.viewModel?.notification.userIsFollowed.toggle()
            self.showLoader(false)
        }
    }
    func cell(_ cell: NotificationCell, wantsTounFollow uid: String) {
        showLoader(true)
        UserService.unfollow(uid: uid) { error in
        cell.viewModel?.notification.userIsFollowed.toggle()
            self.showLoader(false)
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postID: String) {
        showLoader(true)
        PostService.getPost(withsPostId: postID) { post in
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.showLoader(false)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    
}
