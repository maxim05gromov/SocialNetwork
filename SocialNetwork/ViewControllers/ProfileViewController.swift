//
//  ProfileViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit
import SnapKit
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: User?
    var editMode = false
    
    
    
    lazy var tableView = UITableView(frame: .null, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Profile")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewPost")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "Post")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return 1
            default: return Model.shared.posts.value?.count ?? 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 150
        case 1: return 40
        default: return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
            case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile", for: indexPath) as! ProfileTableViewCell
            cell.configure(user: user)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewPost", for: indexPath)
            cell.textLabel?.text = "Новый пост"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostTableViewCell
            guard let post = Model.shared.posts.value?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.configure(post: post)
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

#Preview {
    let vc = ProfileViewController()
    vc.user = User(id: 0, name: "Maxim", second_name: "Gromov", birthday: Date(), username: "gromovm237", password: "password", gender: .male)
    return vc
}
