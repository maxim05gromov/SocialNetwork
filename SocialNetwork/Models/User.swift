//
//  User.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//
import Foundation

struct User: Codable, Identifiable{
    let id: Int
    var name: String
    var second_name: String
    var birthday: String
    var username: String
    var password: String
    var image: URL?
    enum Gender: Int, Codable {
        case male = 0
        case female = 1
    }
    var gender: Gender
}
