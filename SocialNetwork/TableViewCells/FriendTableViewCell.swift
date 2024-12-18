//
//  FriendTableViewCell.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/16/24.
//

import UIKit
import SnapKit
class FriendTableViewCell: UITableViewCell {
    lazy var nameLabel = UILabel()
    lazy var avatarImageView = UIImageView()
    lazy var hstack = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
    
    func configure(user: User){
        addSubview(hstack)
        hstack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        hstack.spacing = 10
        avatarImageView.image = UIImage(systemName: "person")
        avatarImageView.backgroundColor = .systemGray
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        nameLabel.text = "\(user.name) \(user.second_name)"
        nameLabel.font = .systemFont(ofSize: 24)
    }

}

