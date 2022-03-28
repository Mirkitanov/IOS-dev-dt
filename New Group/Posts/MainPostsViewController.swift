//
//  MainPostViewController.swift
//  Navigation
//
//  Created by Админ on 17.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class MainPostsViewController: UIViewController {
    
    weak var flowCoordinator: FeedCoordinator?
    
    var post: PostOld?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        
        self.title = post?.title
 
        let infoBarItem: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(openInfo)
        )
        
        self.navigationItem.rightBarButtonItem = infoBarItem
    }
    
    @objc func openInfo() {
        
        flowCoordinator?.gotoInfo()
    }
    
    
}
