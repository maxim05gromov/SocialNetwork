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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
//    func clicked(){
//        print("clicked \(contentTextLabel.text)")
//        contentTextLabel.numberOfLines = 0
//    }
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
        userAvatar.backgroundColor = .red
        userAvatar.layer.cornerRadius = 50 / 2
        userAvatar.clipsToBounds = true
        userAvatar.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalTo(hstack)
        }
        
        
        usernameLabel.text = "User"
        usernameLabel.font = .boldSystemFont(ofSize: 24)
        
        dateLabel.text = "5 cекунд назад"
        dateLabel.font = .systemFont(ofSize: 16)
        
        contentTextLabel.font = .systemFont(ofSize: 20)
        contentTextLabel.text = post.text
        contentTextLabel.numberOfLines = 0
        
//        watchFullLabel.text = "Посмотреть полностью"
//        watchFullLabel.font = .systemFont(ofSize: 16)
//        watchFullLabel.textColor = .systemGray
//        
//        if contentTextLabel.calculateMaxLines() < 6 {
//            watchFullLabel.isHidden = true
//        }
        
        if post.image != nil {
            image.image = UIImage(named: "test_image")
            image.backgroundColor = .red
            image.contentMode = .scaleAspectFit
            let koef: Double = image.image!.size.height / image.image!.size.width
            image.snp.makeConstraints { make in
                make.width.equalTo(hstack)
                make.height.equalTo(hstack.snp.width).multipliedBy(koef)
            }
            image.clipsToBounds = true
            image.isHidden = false
            image.layer.cornerRadius = 10
        }else{
            image.isHidden = true
        }
    }
    
    
}

#Preview {
    let cell = PostTableViewCell()
    let post = Post(id: 0, likes: [], text: "Hello World", image: URL("http://www.vk.com"), userID: 0, timestamp: Date(), comments: [])
    cell.configure(post: post)
    return cell
}
