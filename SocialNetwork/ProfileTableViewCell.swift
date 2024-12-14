//
//  ProfileTableViewCell.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit
import SnapKit
class ProfileTableViewCell: UITableViewCell {
    
    lazy var profileImageView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var secondNameLabel = UILabel()
    
    lazy var nameVStack = UIStackView(arrangedSubviews: [nameLabel, secondNameLabel])
    lazy var imageNameStackView = UIStackView(arrangedSubviews: [profileImageView, nameVStack])
    
    func configure(user: User?){
        let name = user?.name ?? ""
        let secondName = user?.second_name ?? ""
        
        imageNameStackView.axis = .horizontal
        nameVStack.axis = .vertical
        
        addSubview(imageNameStackView)
        imageNameStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        
        profileImageView.image = UIImage(systemName: "person")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .yellow
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        nameLabel.text = name
        secondNameLabel.text = secondName
    }

}
