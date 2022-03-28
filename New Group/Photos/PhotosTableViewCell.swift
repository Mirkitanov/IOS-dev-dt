//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Админ on 17.02.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
  
    private let titlePhotosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Photos"
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "arrow")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var viewStack: UIStackView = {
        let viewStack = UIStackView()
        for i in 0...3 {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 6
            imageView.image = UIImage(named: PhotoSet.photoSet[i].imageName ?? "")
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            viewStack.addArrangedSubview(imageView)
        }
        viewStack.alignment = .fill
        viewStack.distribution = .fillEqually
        viewStack.contentMode = .scaleAspectFill
        viewStack.axis = .horizontal
        viewStack.spacing = 8
        viewStack.translatesAutoresizingMaskIntoConstraints = false
        return viewStack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    
}
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubviews(titlePhotosLabel)
        contentView.addSubviews(viewStack)
        contentView.addSubviews(arrowImageView)
        
        let constraints = [
            
            titlePhotosLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titlePhotosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            viewStack.topAnchor.constraint(equalTo: titlePhotosLabel.bottomAnchor, constant: 12),
            viewStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            viewStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            viewStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            viewStack.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25, constant: -(8 * 3 + 12 * 2) / 4),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImageView.centerYAnchor.constraint(equalTo: titlePhotosLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalTo: viewStack.heightAnchor, multiplier: 0.3),
            arrowImageView.widthAnchor.constraint(equalTo: arrowImageView.heightAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none

        // Configure the view for the selected state
    }


}

