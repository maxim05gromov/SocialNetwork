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
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: "Conversation")
        navigationItem.title = "Чаты"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        Model.shared.conversations.bind { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        Model.shared.loadConversations {
            print("loaded")
        } onError: { error in
            DispatchQueue.main.async {
                self.presentAlert(title: "Ошибка", message: error)
            }
        }

        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.conversations.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Conversation") as? ConversationTableViewCell
        guard let cell else {return UITableViewCell()}
        guard let conversations = Model.shared.conversations.value else {return UITableViewCell()}
        let conversation = conversations[indexPath.row]
        cell.configure(conversation: conversation)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let conversations = Model.shared.conversations.value else {return}
        let conversation = conversations[indexPath.row]
        let vc = ChatViewController(conversation: conversation)
        navigationController?.pushViewController(vc, animated: true)
    }

}
#Preview {
    let vc = ConversationsViewController()
    return vc
}
