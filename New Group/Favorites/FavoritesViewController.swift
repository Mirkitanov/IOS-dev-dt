//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Админ on 15.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    weak var flowCoordinator: FavoritesCoordinator?

    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    var dataModel = DataStorageModel()
    
    var items: [DataPostModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        items = dataModel.getFavoritePosts()
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupViews()
    }
    
    private func setupTable(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
    }
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    var cellHeight: CGFloat {return (view.frame.width - 24 - (8*3)) / (view.frame.width * 4)}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = items.count
        return tableSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        let post = items[indexPath.row]
        let postForCell = dataModel.dataPostToPost(post: post)
        cell.postInScreen = postForCell
        
        return cell
    }
    
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}
