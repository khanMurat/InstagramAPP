//
//  LikeController.swift
//  InstagramTutorial
//
//  Created by Murat on 13.06.2023.
//

import UIKit

private let reusueIdentifier = "Cell"

class LikeController : UITableViewController {
    
    
    //MARK: - Properties
    
    var likesUsers = [User]() {
        
        didSet {tableView.reloadData()}
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        print(likesUsers.count)
        
    }
    
    //MARK: - Helpers
    
    func configureTableView(){
        
        tableView.rowHeight = 64
        
        tableView.backgroundColor = .white
        
        tableView.register(LikeCell.self, forCellReuseIdentifier: reusueIdentifier)
        
        navigationItem.title = "Likes"
    }
    
}

extension LikeController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusueIdentifier) as! LikeCell
        
        cell.viewModel = LikeViewModel(user: likesUsers[indexPath.row])
        
        return cell
    }
    
    
}
