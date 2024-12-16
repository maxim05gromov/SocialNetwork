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
//    lazy var imageView = UIImageView()
//    lazy var imagePickerController = UIImagePickerController()
//    lazy var imageButton = UIButton()
    lazy var vstack = UIStackView(arrangedSubviews: [textView]) //[imageButton, imageView, textView])
    lazy var scrollView = UIScrollView()
    var koef: Double = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Новый пост"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отправить", style: .done, target: self, action: #selector(send))
        
        //imagePickerController.sourceType = .photoLibrary
        //imagePickerController.delegate = self
        
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
        
//        imageButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        imageButton.setTitle("Выбрать изображение", for: .normal)
//        imageButton.setTitleColor(.white, for: .normal)
//        imageButton.backgroundColor = .systemGray3
//        imageButton.layer.cornerRadius = 10
//        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
//        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true
        
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
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        imagePickerController.dismiss(animated: true)
//        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        imageView.isHidden = false
//        imageView.setNeedsUpdateConstraints()
//        koef = imageView.image!.size.height / imageView.image!.size.width
//        imageView.snp.makeConstraints { make in
//            make.centerX.equalTo(vstack)
//            make.width.equalTo(vstack)
//            make.height.equalTo(imageView.snp.width).multipliedBy(koef)
//        }
//        imageButton.isHidden = true
//    }
    @objc func send() {
        Model.shared.newPost(text: textView.text) {
            DispatchQueue.main.async{
                self.textView.text = ""
                self.navigationController?.popViewController(animated: true)
            }
        } onError: { error in
            self.presentAlert(title: "Ошибка", message: error)
        }
    }
//    @objc func selectImage() {
//        present(imagePickerController, animated: true)
//    }

}
#Preview {
    NewPostViewController()
}
