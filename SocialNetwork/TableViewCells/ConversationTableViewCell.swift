//
//  ConversationTableViewCell.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/16/24.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    lazy var nameLabel = UILabel()
    lazy var lastMessageLabel = UILabel()
    lazy var avatarImageView = UIImageView()
    lazy var vstack = UIStackView(arrangedSubviews: [nameLabel, lastMessageLabel])
    lazy var hstack = UIStackView(arrangedSubviews: [avatarImageView, vstack])
    
    func configure(conversation: Conversation){
        addSubview(hstack)
        hstack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        hstack.spacing = 10
        vstack.axis = .vertical
        avatarImageView.image = UIImage(systemName: "person")
        avatarImageView.backgroundColor = .systemGray
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        nameLabel.text = "\(conversation.user.name) \(conversation.user.second_name)"
        nameLabel.font = .systemFont(ofSize: 24)
        
        lastMessageLabel.text = conversation.messages.last?.text
        lastMessageLabel.font = .systemFont(ofSize: 16)
    }
}
