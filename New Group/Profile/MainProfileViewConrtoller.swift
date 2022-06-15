//
//  MainProfileViewController.swift
//  Navigation
//
//  Created by Админ on 16.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class MainProfileViewController: UIViewController {
    
    weak var flowCoordinator: ProfileCoordinator?
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var dropSessionItemsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViews()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

extension MainProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostStorage.tableModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if PostStorage.tableModel[section].type == .photos
        
        { return 1 }
        
        else {
            
            return PostStorage.tableModel[section].posts?.count ?? 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch PostStorage.tableModel[indexPath.section].type {
        case .photos:
            let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self), for: indexPath) as! PhotosTableViewCell
            return cell
        case .posts:
            let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
            
            let tableSection: PostSection = PostStorage.tableModel[indexPath.section]
            let post: Post = tableSection.posts![indexPath.row]
            cell.postInScreen = post
            
            return cell
        }
    }
}

extension MainProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return .zero }
        
        return 220
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = MainProfileHeaderView()
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            flowCoordinator?.gotoPhotos()
        default:
            return
        }
    }
}

// MARK: - UITableViewDragDelegate

extension MainProfileViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard let posts = PostStorage.tableModel[indexPath.section].posts?[indexPath.row] else {return []}
        
        guard let image = posts.image else {return []}
        
        let dragImageItem = UIDragItem(itemProvider: NSItemProvider(object: image))
        
        let descr = posts.description
        
        let dragDescrItem = UIDragItem(itemProvider: NSItemProvider(object: NSString(string: descr)))
        
        return [dragDescrItem, dragImageItem]
    }
}

// MARK: - UITableViewDropDelegate
extension MainProfileViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self) ||
            session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        
        dropSessionItemsCount = session.items.count
        
        var dropProposal = UITableViewDropProposal(operation: .cancel)
        
        guard let destinationIndexPath = destinationIndexPath, PostStorage.tableModel[destinationIndexPath.section].type == .posts else {
            return dropProposal
        }
        
        dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        return dropProposal
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        var currentImage = UIImage()
        var currentString = ""
        var indexPaths = [IndexPath]()
        var currentIndexPath: IndexPath
        var currentDropItemNumber = 0
        
        var dragAndDropPost = Post(image: currentImage,
                                   name: "Drag&Drop",
                                   likes: "",
                                   views: "",
                                   description: currentString)
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        currentIndexPath = destinationIndexPath
        
        coordinator.session.loadObjects(ofClass: NSString.self)  {[weak self] items in
            
            guard let self = self else {
                return
            }
            // Consume drag items.
            guard let stringItems = items as? [String] else { return }
            
            if let itemString = stringItems.first {
                
                let indexPathItemString = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section)
                
                currentDropItemNumber += 1
                
                currentIndexPath = indexPathItemString
                
                currentString = itemString
                
                dragAndDropPost.description = currentString
                
            } else {
                print("Обрабатываем только 1 string айтем")
                return
            }
            
            if currentDropItemNumber == self.dropSessionItemsCount {
                addDragAndDropPostInTableView()
            }
        }
        
        coordinator.session.loadObjects(ofClass: UIImage.self)  {[weak self] items in
            
            guard let self = self else {
                return
            }
            // Consume drag items.
            guard let imageItems = items as? [UIImage] else { return }
            
            if let itemImage = imageItems.first {
                
                let indexPathItemImage = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section)
                
                currentDropItemNumber += 1
                
                currentIndexPath = indexPathItemImage
                
                currentImage = itemImage
                
                dragAndDropPost.image = currentImage
                
            } else {
                print("Обрабатываем только 1 Image айтем")
                return
            }
            
            if currentDropItemNumber == self.dropSessionItemsCount {
                addDragAndDropPostInTableView()
            }
        }
        
        func addDragAndDropPostInTableView(){
            
            PostStorage.addPostItem(dragAndDropPost, indexSection: currentIndexPath.section, indexRow: currentIndexPath.row)
            
            indexPaths.append(currentIndexPath)
            
            print("indexPaths  = \(indexPaths)")
            
            tableView.insertRows(at: indexPaths, with: .automatic)
            
            tableView.reloadData()
        }
    }
}

