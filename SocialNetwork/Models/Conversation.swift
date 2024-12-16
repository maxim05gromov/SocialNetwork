//
//  Conversation.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/16/24.
//

class Conversation: Codable {
    let id: Int
    let user: User
    let messages: [Message]
    init(id: Int, user: User, messages: [Message]) {
        self.id = id
        self.user = user
        self.messages = messages
    }
}
