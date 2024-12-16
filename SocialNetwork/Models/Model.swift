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
    
    private var sessionID: String?
    
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    private func request(endpoint: String,
                 method: Method = .get,
                 sessionKey: Bool = false,
                 arguments: [String: Any] = [:],
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
        }else if arguments.count > 0{
            urlString += "?"
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
            completionHandler()
        } onError: { error in
            onError(error)
        }
    }
    
    func loadAvatar(source: URL, completionHandler: @escaping(Data?) -> ()) {
        
    }
    
    func loadNews(completionHandler: @escaping() -> (), onError: @escaping(String) -> ()) {
        request(endpoint: "posts", sessionKey: true) { data in
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
    
}

