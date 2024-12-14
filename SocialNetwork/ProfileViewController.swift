//
//  ProfileViewController.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit
import SnapKit
class ProfileViewController: UIViewController {
    
    var user: User?
    var editMode = false
    
    lazy var profileImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func displayProfile() {
        
    }
}

#Preview {
    let vc = ProfileViewController()
    vc.user = User(id: 0, name: "Maxim", second_name: "Gromov", birthday: Date(), username: "gromovm237", password: "password", gender: .male)
    return vc
}
