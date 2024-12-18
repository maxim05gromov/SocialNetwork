//
//  ChatViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/16/24.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController, UITextFieldDelegate {
    lazy var scrollView = UIScrollView()
    lazy var leadingStackView = UIStackView()
    lazy var trailingStackView = UIStackView()
    lazy var textField = UITextField()
    lazy var textFieldView = UIView()
    lazy var sendButton = UIButton()
    lazy var backgroundView = UIView()
    var conversation: Conversation
    var user = Model.shared.profile.value?.id ?? 0
    
    init(conversation: Conversation,
         user: Int = Model.shared.profile.value?.id ?? 0) {
        self.conversation = conversation
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadData() {
        let subviews = self.leadingStackView.arrangedSubviews + self.trailingStackView.arrangedSubviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        print("load data \(self.conversation.messages.count)")
        for m in self.conversation.messages {
            if m.from == self.user {
                let messageView = UIView()
                messageView.backgroundColor = .systemCyan
                messageView.layer.cornerRadius = 10
                
                let label = UILabel()
                label.text = m.text
                label.textAlignment = .right
                label.font = .systemFont(ofSize: 20)
                label.textColor = .white
                
                label.numberOfLines = 0
                messageView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(7)
                }
                self.trailingStackView.addArrangedSubview(messageView)
                
                let view = UIView()
                self.leadingStackView.addArrangedSubview(view)
                view.snp.makeConstraints { make in
                    make.height.equalTo(messageView)
                    make.trailing.equalTo(self.trailingStackView)
                }
                
                messageView.snp.makeConstraints { make in
                    make.trailing.equalTo(self.trailingStackView)
                    make.width.lessThanOrEqualTo(self.scrollView).multipliedBy(0.75)
                }
            }else{
                let messageView = UIView()
                messageView.backgroundColor = .systemGray5
                messageView.layer.cornerRadius = 10
                
                let label = UILabel()
                label.text = m.text
                label.textAlignment = .left
                label.font = .systemFont(ofSize: 20)
                label.textColor = .black
                
                label.numberOfLines = 0
                messageView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(7)
                }
                self.leadingStackView.addArrangedSubview(messageView)
                
                let view = UIView()
                self.trailingStackView.addArrangedSubview(view)
                view.snp.makeConstraints { make in
                    make.height.equalTo(messageView)
                    make.leading.equalTo(self.leadingStackView)
                }
                
                messageView.snp.makeConstraints { make in
                    make.leading.equalTo(self.leadingStackView)
                    make.width.lessThanOrEqualTo(self.scrollView).multipliedBy(0.75)
                }
            }
            self.view.layoutIfNeeded()
            let bottomOffset = CGPoint(x: -5, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
            self.scrollView.setContentOffset(bottomOffset, animated: false)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\(conversation.user.name) \(conversation.user.second_name)"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(backgroundView)
        view.addSubview(textFieldView)
        
        textFieldView.addSubview(textField)
        textFieldView.addSubview(sendButton)
        
        textFieldView.backgroundColor = .systemGray6
        backgroundView.backgroundColor = .systemGray6
        
        textField.placeholder = "Введите сообщение..."
        textField.borderStyle = .roundedRect
        textField.resignFirstResponder()
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textFieldView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(textFieldView.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(5)
            make.trailing.equalTo(sendButton.snp.leading).inset(-5)
            make.height.equalTo(35)
        }
        sendButton.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(5)
        }
        sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = .systemBlue
        sendButton.layer.cornerRadius = 35 / 2
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        scrollView.addSubview(trailingStackView)
        scrollView.addSubview(leadingStackView)
        scrollView.contentInset.left = 5
        scrollView.contentInset.right = 5
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(textFieldView.snp.top).offset(-10)
        }
        trailingStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView)
            make.width.equalTo(scrollView).offset(-10)
            make.bottom.equalToSuperview()
        }
        leadingStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView)
            make.width.equalTo(scrollView).offset(-10)
            make.bottom.equalToSuperview()
        }
        
        trailingStackView.axis = .vertical
        trailingStackView.spacing = 4
        trailingStackView.alignment = .trailing
        
        leadingStackView.axis = .vertical
        leadingStackView.spacing = 4
        leadingStackView.alignment = .leading
        loadData()
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight: CGFloat = keyboardSize.height - view.safeAreaInsets.bottom + 50
        UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseInOut, animations: {
            UIView.animate(withDuration: 0.3) {
                self.textFieldView.snp.updateConstraints { make in
                    print("willshow \(keyboardHeight)")
                    make.height.equalTo(keyboardHeight)
                }
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseInOut, animations: {
            UIView.animate(withDuration: 0.3) {
                self.textFieldView.snp.updateConstraints { make in
                    make.height.equalTo(50)
                }
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
    @objc func send(){
        self.textField.endEditing(true)
        Model.shared.newMessage(text: textField.text ?? "", convID: conversation.id) { conversation in
            self.conversation = conversation
            self.loadData()
            self.textField.text = ""
        } onError: { error in
            self.presentAlert(title: "Ошибка", message: error)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send()
        return true
    }
}
