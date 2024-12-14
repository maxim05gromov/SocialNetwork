//
//  ConversationsViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit

class ConversationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        navigationItem.title = "Чаты"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
#Preview {
    let vc = ConversationsViewController()
    return vc
}
