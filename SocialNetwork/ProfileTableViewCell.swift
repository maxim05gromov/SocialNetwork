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
    lazy var divider = UIView()
    lazy var imageNameStackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
    lazy var vstackView = UIStackView(arrangedSubviews: [imageNameStackView, divider])
    
    func makeInfoRow(name: String, text: String) -> UIStackView{
        let nameLabel = UILabel()
        nameLabel.text = name
        let textLabel = UILabel()
        textLabel.text = text
        
        var stackView = UIStackView(arrangedSubviews: [nameLabel, textLabel])
        stackView.axis = .horizontal
        return stackView
    }
    
    func configure(user: User?){
        let name = user?.name ?? ""
        let secondName = user?.second_name ?? ""
        
        imageNameStackView.axis = .horizontal
        imageNameStackView.spacing = 10
        
        addSubview(vstackView)
        vstackView.axis = .vertical
        vstackView.spacing = 10
        vstackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        
        imageNameStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        profileImageView.image = UIImage(systemName: "person")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .red
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.masksToBounds = true
        
        nameLabel.text = "\(name)\n\(secondName)"
        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        
        divider.backgroundColor = .lightGray
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        vstackView.addArrangedSubview(makeInfoRow(name: "Дата рождения", text: "23.03.2005"))
        vstackView.addArrangedSubview(makeInfoRow(name: "Пол", text: "мужской"))
    }

}
