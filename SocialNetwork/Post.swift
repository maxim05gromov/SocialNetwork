//
//  Post.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import Foundation

class Post: Codable, Identifiable {
    let id: Int
    var likes: [User]
    let text: String
    let image: URL?
    let userID: Int
    let timestamp: Date
    var comments: [Comment]
    init(id: Int, likes: [User], text: String, image: URL?, userID: Int, timestamp: Date, comments: [Comment]) {
        self.id = id
        self.likes = likes
        self.text = text
        self.image = image
        self.userID = userID
        self.timestamp = timestamp
        self.comments = comments
    }
}
struct Comment: Codable, Identifiable {
    let id: Int
    let userID: Int
    let text: String
    let timestamp: Date
}
