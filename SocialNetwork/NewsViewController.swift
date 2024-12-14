//
//  ViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit
import SnapKit
class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView = UITableView(frame: CGRect.null, style: .insetGrouped)
    lazy var buttonView = UIButton()
    lazy var noPostsLabel = UILabel()
    lazy var activityIndicator = UIActivityIndicatorView()
    
    var loadingNews = true
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let posts = Model.shared.news.value?.count ?? 0
        noPostsLabel.isHidden = posts > 0 || loadingNews
        return posts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = Model.shared.news.value?[indexPath.row] else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Не удалось загрузить пост"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as? PostTableViewCell
        guard let cell else { return UITableViewCell() }
        cell.configure(post: post)
        return cell
    }
    
    override func viewDidLoad() {
        Model.shared.login(username: "maxim", password: "password"){ error in
            if let error {
                print(error)
            }else{
                print("logged in")
                Model.shared.loadNews(completionHandler: { error in
                    if let error {
                        print(error)
                    }else{
                        print("Loaded?")
                    }
                })
            }
        }
        
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Новости"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "Post")
        
        Model.shared.news.bind { _ in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
        noPostsLabel.text = "Новостей нет"
        noPostsLabel.textAlignment = .center
        noPostsLabel.font = .boldSystemFont(ofSize: 30)
        view.addSubview(noPostsLabel)
        noPostsLabel.snp.makeConstraints { make in
            make.center.equalTo(view.center)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
        activityIndicator.style = .large
        activityIndicator.startAnimating()

    }
    

}

#Preview{
    let vc = NewsViewController()
    let navigationController = UINavigationController(rootViewController: vc)
    return navigationController
}
