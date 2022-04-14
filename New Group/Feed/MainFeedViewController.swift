//
//  MainFeedViewController.swift
//  Navigation
//
//  Created by Админ on 17.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController {
    
//MARK:- Properties
    
    weak var flowCoordinator: FeedCoordinator?
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    var output: FeedViewOutputProtocol
    
    var openPostButton: UIButton = {
       let openPostButton = UIButton()
        openPostButton.translatesAutoresizingMaskIntoConstraints = false
        openPostButton.setTitle("Open Post", for: .normal)
        openPostButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        openPostButton.setTitleColor(UIColor(named: "Hex-code: #4885CC"), for: .normal)
        openPostButton.setTitleColor(.label, for: .selected)
        openPostButton.setTitleColor(.darkGray, for: .highlighted)
        openPostButton.isUserInteractionEnabled = true
        openPostButton.addTarget(self, action: #selector(openPostButtonPressed), for: .touchUpInside)
        return openPostButton
    }()
    
    let post: PostOld = PostOld(title: "Пост")
    
    init(output: FeedViewOutputProtocol) {
        self.output = output
        super.init(nibName:nil, bundle:.main)
    }
    
    required init?(coder: NSCoder) {
        print(type(of: self), #function)
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(type(of: self), #function)
        self.view.backgroundColor = .systemGreen
        self.title = "Feed"
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(type(of: self), #function)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(type(of: self), #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(type(of: self), #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(type(of: self), #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(type(of: self), #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(type(of: self), #function)
    }
    
//MARK:- Private methods
    
  private func layoutUI() {
        self.view.addSubviews(openPostButton)
        
        let constraints = [
            openPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPostButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
            
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc private func openPostButtonPressed () {
        output.showPost(post)
        
    }
}
