//
//  Message.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/16/24.
//

import Foundation


struct Message: Codable {
    let id: Int
    let from: Int
    let text: String
    init(id: Int, from: Int, text: String) {
        self.id = id
        self.from = from
        self.text = text
    }
}
