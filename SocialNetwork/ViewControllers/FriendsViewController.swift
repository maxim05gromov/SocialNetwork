//
//  FriendsViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit
import SnapKit
class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    lazy var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Друзья"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "Friend")
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        Model.shared.friends.bind { _ in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
        Model.shared.loadFriends {
            print("loaded")
        } onError: { error in
            DispatchQueue.main.async {
                self.presentAlert(title: "Ошибка", message: error)
            }
        }

        
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }
    
    @objc func addFriend() {
        print("addFriend")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.friends.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as? FriendTableViewCell
        guard let cell else { return UITableViewCell() }
        guard let friends = Model.shared.friends.value else {
            return UITableViewCell()
        }
        cell.configure(user: friends[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let friends = Model.shared.friends.value else {
            return
        }
        let friend = friends[indexPath.row]
        let vc = ProfileViewController()
        vc.user = friend
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

#Preview {
    FriendsViewController()
}
