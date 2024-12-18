//
//  PostTableViewCell.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    lazy var usernameLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var userAvatar = UIImageView()
    lazy var contentTextLabel = UILabel()
    lazy var image = UIImageView()
    lazy var watchFullLabel = UILabel()
    
    lazy var hstack = UIStackView(arrangedSubviews: [userAvatar, vstack])
    lazy var vstack = UIStackView(arrangedSubviews: [usernameLabel, dateLabel])
    lazy var stackView = UIStackView(arrangedSubviews: [hstack, contentTextLabel, watchFullLabel, image])
    func configure(post: Post) {
        addSubview(stackView)
        
        hstack.snp.makeConstraints { make in
            make.top.trailing.trailing.equalTo(stackView)
        }
        hstack.spacing = 10
        
        stackView.axis = .vertical
        stackView.spacing = 10
        vstack.axis = .vertical
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self).inset(10)
        }
        
        userAvatar.image = UIImage(systemName: "person")
        userAvatar.backgroundColor = .systemGray
        userAvatar.layer.cornerRadius = 50 / 2
        userAvatar.clipsToBounds = true
        userAvatar.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalTo(hstack)
        }
        
        usernameLabel.text = "\(post.user.name) \(post.user.second_name)"
        usernameLabel.font = .boldSystemFont(ofSize: 24)
        
        dateLabel.text = post.timestamp
        dateLabel.font = .systemFont(ofSize: 16)
        
        contentTextLabel.font = .systemFont(ofSize: 20)
        contentTextLabel.text = post.text
        contentTextLabel.numberOfLines = 0
        image.isHidden = true
    }
}

