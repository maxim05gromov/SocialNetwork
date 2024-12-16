//
//  MainViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit
import SnapKit
class MainViewController: UIViewController {
    lazy var mainLabel = UILabel()
    lazy var enterButton = UIButton()
    lazy var registerButton = UIButton()
    lazy var registerLabel = UILabel()
    lazy var loginButton = UIButton()
    
    lazy var usernameTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var datePicker = UIDatePicker()
    lazy var picker = UIPickerView()
    
    lazy var stackView = UIStackView()
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    var registerMode = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.registerMode{
                    self.mainLabel.text = "Добро пожаловать"
                    self.datePicker.isHidden = false
                    self.picker.isHidden = false
                    self.enterButton.setTitle("Создать аккаунт", for: .normal)
                    self.registerLabel.text = "Уже есть аккаунт?"
                    self.registerButton.setTitle("Войти", for: .normal)
                }else {
                    self.mainLabel.text = "Вход в аккаунт"
                    self.datePicker.isHidden = true
                    self.picker.isHidden = true
                    self.enterButton.setTitle("Войти", for: .normal)
                    self.registerLabel.text = "Еще нет аккаунта?"
                    self.registerButton.setTitle("Зарегистрироваться", for: .normal)
                }
            }
        }
    }
    func showTabBarController(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let tabBarController = UITabBarController()
            
            let newsVC = UINavigationController(rootViewController: NewsViewController())
            newsVC.title = "Новости"
            newsVC.tabBarItem.image = UIImage(systemName: "newspaper")
            
            let conversationVC = UINavigationController(rootViewController: ConversationsViewController())
            conversationVC.title = "Чаты"
            conversationVC.tabBarItem.image = UIImage(systemName: "message")
            
            let profileContentVC = ProfileViewController()
            let profileVC = UINavigationController(rootViewController: profileContentVC)
            profileVC.title = "Профиль"
            profileVC.tabBarItem.image = UIImage(systemName: "person")
            profileContentVC.user = Model.shared.profile.value
            
            let friendsVC = UINavigationController(rootViewController: FriendsViewController())
            friendsVC.title = "Друзья"
            friendsVC.tabBarItem.image = UIImage(systemName: "person.circle")
            
            tabBarController.viewControllers = [newsVC, conversationVC, friendsVC, profileVC]
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.isHidden = true
        activityIndicator.style = .large
        
        Model.shared.loadProfile { _ in
            self.showTabBarController()
        } onError: { _ in
            DispatchQueue.main.async {
                self.stackView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
        
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(mainLabel)
        mainLabel.textAlignment = .center
        mainLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        mainLabel.font = .boldSystemFont(ofSize: 35)
        
        
        stackView.addArrangedSubview(usernameTextField)
        stackView.spacing = 30
        usernameTextField.placeholder = "Имя пользователя"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        
        stackView.addArrangedSubview(loginButton)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 15
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 10)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(registerLabel)
        registerLabel.textAlignment = .center
        
        stackView.addArrangedSubview(registerButton)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom)
        }
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerMode = false
        
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
    
    @objc func loginButtonTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            self.presentAlert(title: "Введите логин и пароль", message: "Вы не ввели логин или пароль  Проверьте введенные данные")
            return
        }
        if username.isEmpty || password.isEmpty {
            self.presentAlert(title: "Введите логин и пароль", message: "Вы не ввели логин или пароль  Проверьте введенные данные")
            return
        }
        
        if registerMode{
            
        }else{
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            stackView.isHidden = true
            
            Model.shared.login(username: username, password: password) {
                DispatchQueue.main.async{
                    self.activityIndicator.stopAnimating()
                    self.showTabBarController()
                }
            } onError: { error in
                DispatchQueue.main.async{
                    self.activityIndicator.stopAnimating()
                    self.stackView.isHidden = false
                    self.presentAlert(title: "Ошибка", message: error)
                }
            }
        }
    }
    
    @objc func registerButtonTapped() {
        registerMode = !registerMode
    }
}

#Preview {
    MainViewController()
}
