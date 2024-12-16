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
    lazy var refreshControl = UIRefreshControl()
    
    var loadingNews = true
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let posts = Model.shared.news.value?.count ?? 0
        noPostsLabel.isHidden = posts > 0 || loadingNews
        return posts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = Model.shared.news.value?[indexPath.section] else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Не удалось загрузить пост"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as? PostTableViewCell
        guard let cell else { return UITableViewCell() }
        cell.configure(post: post)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell
    //        guard let cell else { return }
    //        cell.clicked()
    //        tableView.reloadRows(at: [indexPath], with: .fade)
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Новости"
        
        
        
        
        Model.shared.loadNews {
            print("News loaded")
        } onError: { error in
            self.presentAlert(title: "Ошибка", message: error)
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "Post")
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
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
    
    @objc func refresh(_ sender: AnyObject) {
        Model.shared.loadNews {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        } onError: { error in
            self.presentAlert(title: "Ошибка", message: error)
        }

    }
    
}

#Preview{
    let vc = NewsViewController()
    let navigationController = UINavigationController(rootViewController: vc)
    return navigationController
}
