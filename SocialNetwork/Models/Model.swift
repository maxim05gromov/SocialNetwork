//
//  Singleton.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//
import Foundation
class Model {
    let serverURL = "http://192.168.31.204:5001/"
    
    static let shared = Model()
    
    var profile = Bindable<User>()
    var news = Bindable<[Post]>()
    var posts = Bindable<[Post]>()
    var friends = Bindable<[User]>()
    var conversations = Bindable<[Conversation]>()
    
    
    private var sessionID: String?
    
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    private func request(endpoint: String,
                 method: Method = .get,
                 sessionKey: Bool = false,
                 arguments: [String: Any] = [:],
                 body: Data? = nil,
                 completionHandler: @escaping(Data) -> (),
                 onError: @escaping(String) -> ()) {
        var urlString = serverURL + endpoint
        if sessionKey {
            loadSessionKey()
            if let sessionID {
                urlString += "?session_key=\(sessionID)"
            }else{
                onError("Session ID is nil")
                return
            }
        }
        if arguments.count > 0{
            if !sessionKey{
                urlString += "?"
            }else{
                urlString += "&"
            }
            arguments.forEach {
                urlString += "\($0)=\($1)&"
            }
        }
        if urlString.hasSuffix("&") {
            urlString.removeLast()
        }
        print("url: \(urlString)")
        guard let url = URL(string: urlString) else {
            onError("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body {
            request.httpBody = body
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                onError("\(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                onError("Cannot get response")
                return
            }
            guard let data else {
                onError("Cannot decode data")
                return
            }
            if response.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8)
                onError(errorMessage ?? "Unknown error")
            }else{
                completionHandler(data)
            }
        }.resume()
    }
    
    private func loadSessionKey() {
        if sessionID == nil {
            sessionID = UserDefaults.standard.string(forKey: "sessionID")
        }
    }
    
    func loadProfile(completionHandler: @escaping(User) -> (), onError: @escaping(String) -> ()) {
        loadSessionKey()
        if sessionID != nil {
            request(endpoint: "user", sessionKey: true) { data in
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.profile.value = user
                    completionHandler(user)
                }catch let error {
                    onError(error.localizedDescription)
                }
            } onError: { error in
                onError(error)
            }
        } else {
            profile.value = nil
            onError("No session")
        }
    }
    
    func getUser(id: Int, completionHandler: @escaping(String) -> ()){
        
    }
    
    func login(username: String, password: String, completionHandler: @escaping() -> (), onError: @escaping(String) -> ()) {
        let arguments: [String: Any] = [
            "username": username,
            "password": password
        ]
        request(endpoint: "login", method: .post, arguments: arguments) { data in
            self.sessionID = String(data: data, encoding: .utf8)
            UserDefaults.standard.set(self.sessionID, forKey: "sessionID")
            self.loadProfile { _ in
                completionHandler()
            } onError: { _ in
                
            }

            
        } onError: { error in
            onError(error)
        }
    }
    
    func loadAvatar(source: URL, completionHandler: @escaping(Data?) -> ()) {
        
    }
    
    func loadNews(completionHandler: @escaping() -> (), onError: @escaping(String) -> ()) {
        request(endpoint: "news", sessionKey: true) { data in
            do{
                self.news.value = try JSONDecoder().decode([Post].self, from: data)
            }catch let error{
                onError("\(error.localizedDescription)")
            }
        } onError: { error in
            self.news.value = nil
            onError(error)
        }
    }
    
    func loadPosts(completionHandler: @escaping() -> (), onError: @escaping(String) -> ()) {
        request(endpoint: "posts", sessionKey: true) { data in
            do{
                self.posts.value = try JSONDecoder().decode([Post].self, from: data)
            }catch let error{
                onError("\(error.localizedDescription)")
            }
        } onError: { error in
            self.posts.value = nil
            onError(error)
        }
    }
    
    func loadFriends(completionHandler: @escaping() -> (), onError: @escaping(String) -> ()) {
        request(endpoint: "friends", sessionKey: true) { data in
            do{
                self.friends.value = try JSONDecoder().decode([User].self, from: data)
            }catch let error{
                onError("\(error.localizedDescription)")
            }
        } onError: { error in
            self.friends.value = nil
            onError(error)
        }
    }
    
    func logout() {
        profile.value = nil
        posts.value = nil
        friends.value = nil
        news.value = nil
        sessionID = nil
        UserDefaults.standard.removeObject(forKey: "sessionID")
    }
    
    func register(name: String, secondName: String, username: String, password: String, dateOfBirth: String, gender: Int, completionHandler: @escaping() -> (), onError: @escaping(String) -> ()){
        let body: [String: Any] = [
            "name": name,
            "second_name": secondName,
            "username": username,
            "password": password,
            "birthday": dateOfBirth,
            "gender": gender
        ]
        let bodyData = body.percentEncoded()
        request(endpoint: "register", method: .post, body: bodyData) { data in
            self.sessionID = String(data: data, encoding: .utf8)
            UserDefaults.standard.set(self.sessionID, forKey: "sessionID")
            self.loadProfile { _ in
                completionHandler()
            } onError: { _ in
                
            }
            
        } onError: { error in
            onError(error)
        }
    }
    
    func loadConversations(completionHandler: @escaping() -> (), onError: @escaping(String) -> ()) {
        request(endpoint: "conversations", method: .get, sessionKey: true) { data in
            do{
                self.conversations.value = try JSONDecoder().decode([Conversation].self, from: data)
            }catch let error{
                onError(error.localizedDescription)
            }
            completionHandler()
        } onError: { error in
            onError(error)
        }
    }
    
    func newPost(text: String, completionHandler: @escaping() -> (), onError: @escaping(String) -> ()){
        request(endpoint: "new_post", method: .post, sessionKey: true, arguments: ["text": text]) { data in
            completionHandler()
            self.loadPosts {
                
            } onError: { _ in
                
            }

        } onError: { error in
            onError(error)
        }
    }
    
    func newMessage(text: String, convID: Int, completionHandler: @escaping(Conversation) -> (), onError: @escaping(String) -> ()){
        request(endpoint: "new_message", method: .post, sessionKey: true, arguments: [
            "conv_id": convID,
            "text": text]
        ) { data in
            do {
                let conversation = try JSONDecoder().decode(Conversation.self, from: data)
                completionHandler(conversation)
            }catch let error{
                onError(error.localizedDescription)
            }
            
            self.loadConversations {
                
            } onError: { _ in
                
            }

        } onError: { error in
            onError(error)
        }
    }
}

