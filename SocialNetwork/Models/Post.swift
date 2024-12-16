//
//  Post.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import Foundation

class Post: Codable, Identifiable {
    let id: Int
    let text: String
    let user: User
    let timestamp: String
    init(id: Int, text: String, user: User, timestamp: String) {
        self.id = id
        self.text = text
        self.user = user
        self.timestamp = timestamp
    }
}
//struct Comment: Codable, Identifiable {
//    let id: Int
//    let userID: Int
//    let text: String
//    let timestamp: Date
//}
