//
//  NewPostViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/15/24.
//

import UIKit
import SnapKit
class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    lazy var textView = UITextView()
    lazy var vstack = UIStackView(arrangedSubviews: [textView])
    lazy var scrollView = UIScrollView()
    var koef: Double = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Новый пост"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отправить", style: .done, target: self, action: #selector(send))
        view.addSubview(scrollView)
        scrollView.addSubview(vstack)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        scrollView.contentInset.left = 10
        scrollView.contentInset.right = -10
        vstack.axis = .vertical
        vstack.spacing = 10
        vstack.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview().inset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        textView.font = .systemFont(ofSize: 16)
        textView.text = "Текст поста"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @objc func send() {
        Model.shared.newPost(text: textView.text) {
            self.textView.text = ""
            self.navigationController?.popViewController(animated: true)
        } onError: { error in
            self.presentAlert(title: "Ошибка", message: error)
        }
    }
    
}
#Preview {
    NewPostViewController()
}
