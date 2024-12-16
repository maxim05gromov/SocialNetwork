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
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(user: User){
        addSubview(hstack)
        hstack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        hstack.spacing = 10
        avatarImageView.image = UIImage(systemName: "person")
        avatarImageView.backgroundColor = .red
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        nameLabel.text = "\(user.name) \(user.second_name)"
        nameLabel.font = .systemFont(ofSize: 24)
    }

}
#Preview {
    let cell = FriendTableViewCell()
    let user = User(id: 0, name: "Maxim", second_name: "Gromov", birthday: .now, username: "", password: "", gender: .male)
    cell.configure(user: user)
    return cell
    
}
