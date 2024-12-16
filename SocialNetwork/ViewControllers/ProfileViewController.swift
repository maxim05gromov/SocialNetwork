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
    lazy var refreshControl = UIRefreshControl()
    lazy var activityIndicator = UIActivityIndicatorView()
    let newPostVC = NewPostViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Profile")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewPost")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "Post")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        Model.shared.posts.bind { _ in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
        Model.shared.loadPosts {
            print("Posts loaded")
        } onError: { error in
            self.presentAlert(title: "Ошибка", message: error)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }
    @objc func refresh(_ sender: Any) {
        Model.shared.loadPosts {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        } onError: { error in
            self.presentAlert(title: "Ошибка", message: error)
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        let posts = Model.shared.posts.value?.count ?? 0
        return 2 + posts
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            navigationController?.pushViewController(newPostVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.section == 0 && indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            Model.shared.logout()
            dismiss(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
            case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Profile", for: indexPath) as! ProfileTableViewCell
                cell.configure(user: user)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = UITableViewCell()
                cell.textLabel?.text = "Выйти"
                return cell
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewPost", for: indexPath)
            cell.textLabel?.text = "Новый пост"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostTableViewCell
            guard let post = Model.shared.posts.value?[indexPath.section - 2] else {
                return UITableViewCell()
            }
            cell.configure(post: post)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func edit(){
        
    }
}

#Preview {
    let vc = ProfileViewController()
    vc.user = User(id: 0, name: "Maxim", second_name: "Gromov", birthday: Date(), username: "gromovm237", password: "password", gender: .male)
    return UINavigationController(rootViewController: vc)
}
