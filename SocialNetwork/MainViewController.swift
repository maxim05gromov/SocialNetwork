//
//  MainViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let newsVC = UINavigationController(rootViewController: NewsViewController())
        self.viewControllers = [newsVC]
    }
    
}

#Preview {
    MainViewController()
}
