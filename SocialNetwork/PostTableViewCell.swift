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
    lazy var contentTextLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(post: Post) {
        addSubview(usernameLabel)
        usernameLabel.text = "User"
        usernameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self).inset(10)
            make.height.equalTo(20)
        }
        
        addSubview(contentTextLabel)
        contentTextLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.trailing.equalTo(self)
        }
        contentTextLabel.text = post.text
        
    }
}

#Preview {
    let cell = PostTableViewCell()
    let post = Post(id: 0, likes: [], text: "Hello World", image: nil, userID: 0, timestamp: Date(), comments: [])
    cell.configure(post: post)
    return cell
}
