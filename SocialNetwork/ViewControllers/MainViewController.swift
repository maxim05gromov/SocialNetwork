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
    lazy var registerButton = UIButton()
    lazy var registerLabel = UILabel()
    lazy var loginButton = UIButton()
    
    lazy var usernameTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var nameTextField = UITextField()
    lazy var secondTextField = UITextField()
    lazy var datePicker = UIDatePicker()
    lazy var dateLabel = UILabel()
    lazy var dateStack = UIStackView(arrangedSubviews: [dateLabel, datePicker])
    lazy var picker = UISegmentedControl(items: ["Мужской", "Женский"])
    lazy var pickerLabel = UILabel()
    lazy var pickerStack = UIStackView(arrangedSubviews: [pickerLabel, picker])
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        mainLabel,
        usernameTextField,
        passwordTextField,
        nameTextField,
        secondTextField,
        dateStack,
        pickerStack,
        loginButton,
        registerLabel,
        registerButton
    ])
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    var registerMode = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.registerMode{
                    self.mainLabel.text = "Добро пожаловать"
                    self.dateStack.isHidden = false
                    self.pickerStack.isHidden = false
                    self.loginButton.setTitle("Создать аккаунт", for: .normal)
                    self.registerLabel.text = "Уже есть аккаунт?"
                    self.nameTextField.isHidden = false
                    self.secondTextField.isHidden = false
                    self.registerButton.setTitle("Войти", for: .normal)
                }else {
                    self.mainLabel.text = "Вход в аккаунт"
                    self.dateStack.isHidden = true
                    self.pickerStack.isHidden = true
                    self.loginButton.setTitle("Войти", for: .normal)
                    self.registerLabel.text = "Еще нет аккаунта?"
                    self.nameTextField.isHidden = true
                    self.secondTextField.isHidden = true
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
            profileContentVC.editMode = true
            profileContentVC.user = Model.shared.profile.value
            
            let friendsVC = UINavigationController(rootViewController: FriendsViewController())
            friendsVC.title = "Друзья"
            friendsVC.tabBarItem.image = UIImage(systemName: "person.circle")
            
            tabBarController.viewControllers = [newsVC, conversationVC, friendsVC, profileVC]
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: false)
            self.stackView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
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
            self.stackView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
        
        stackView.axis = .vertical
        
        mainLabel.textAlignment = .center
        mainLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        mainLabel.font = .boldSystemFont(ofSize: 35)
        
        
        stackView.spacing = 30
        usernameTextField.placeholder = "Имя пользователя"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 15
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        registerLabel.textAlignment = .center
        
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom)
        }
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerMode = false
        
        picker.selectedSegmentIndex = 0
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        pickerLabel.text = "Пол:"
        dateLabel.text = "Дата рождения:"
        pickerStack.snp.makeConstraints { make in
            make.top.equalTo(dateStack.snp.bottom).offset(10)
        }
        
        nameTextField.borderStyle = .roundedRect
        nameTextField.placeholder = "Имя"
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        
        secondTextField.borderStyle = .roundedRect
        secondTextField.placeholder = "Фамилия"
        secondTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(5)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
    
    @objc func loginButtonTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            self.presentAlert(title: "Введите логин и пароль", message: "Вы не ввели логин или пароль. Проверьте введенные данные")
            return
        }
        if username.isEmpty || password.isEmpty {
            self.presentAlert(title: "Введите логин и пароль", message: "Вы не ввели логин или пароль. Проверьте введенные данные")
            return
        }
        
        if registerMode{
            guard let name = nameTextField.text, let secondName = secondTextField.text else {
                self.presentAlert(title: "Введите имя и фамилию", message: "Вы не ввели имя или фамилию. Проверьте введенные данные")
                return
            }
            if name.isEmpty || secondName.isEmpty {
                self.presentAlert(title: "Введите имя и фамилию", message: "Вы не ввели имя или фамилию. Проверьте введенные данные")
                return
            }
            let date = datePicker.date
            let gender = picker.selectedSegmentIndex
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let formattedDate = dateFormatter.string(from: date)
            
            Model.shared.register(name: name, secondName: secondName, username: username, password: password, dateOfBirth: formattedDate, gender: gender) {
                self.showTabBarController()
            } onError: { error in
                self.presentAlert(title: "Ошибка", message: error)
            }
        }else{
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            stackView.isHidden = true
            
            Model.shared.login(username: username, password: password) {
                self.activityIndicator.stopAnimating()
                self.showTabBarController()
            } onError: { error in
                self.activityIndicator.stopAnimating()
                self.stackView.isHidden = false
                self.presentAlert(title: "Ошибка", message: error)
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
