//
//  MainInfoViewController.swift
//  Navigation
//
//  Created by Админ on 17.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class MainInfoViewController: UIViewController {
    
    weak var flowCoordinator: FeedCoordinator?
    
    var cancelFinalAction: (() -> Void)?
    var deleteFinalAction: (() -> Void)?
    
    let alertButton: UIButton = {
        let alertButton = UIButton()
        alertButton.setTitleColor(.blue, for: .normal)
        alertButton.setTitle("Show alert", for: .normal)
        alertButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        alertButton.setTitleColor(UIColor(named: "Hex-code: #4885CC"), for: .normal)
        alertButton.setTitleColor(.darkGray, for: .highlighted)
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        alertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        return alertButton
    }()
    
    var textForLabel: String?
    var textOrbitalLabel: String?
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let orbitalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemYellow
        layoutUI()
    }
    
    private func layoutUI(){
        view.addSubviews(alertButton,
                         textLabel,
                         orbitalLabel)
        
        textLabel.text = JsonParsing.textForLabel
        orbitalLabel.text = JsonParsing.orbital
        
        let constraints = [
            alertButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            textLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -15),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            orbitalLabel.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -5),
            orbitalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
            
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func showAlert(_ sender: Any) {
        let alertController = UIAlertController(title: "Удалить пост?", message: "Пост нельзя будет восстановить", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            print("Отмена")
            if let nvc = self.navigationController {
                // if it use navigation controller, just pop ViewController
                nvc.popViewController(animated: true)
            } else {
                // otherwise, dismiss it
                self.dismiss(animated: true, completion: nil)
            }
            self.cancelFinalAction?()
            
        }
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            print("Удалить")
            if let nvc = self.navigationController {
                // if it use navigation controller, just pop ViewController
                nvc.popViewController(animated: true)
            } else {
                // otherwise, dismiss it
                self.dismiss(animated: true, completion: nil)
            }
            self.deleteFinalAction?()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

