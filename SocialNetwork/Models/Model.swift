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
    
    func loadSessionKey() {
        sessionID = UserDefaults.standard.string(forKey: "sessionID")
        if let sessionID {
            print("loaded")
        }
    }
    func loadProfile(completionHandler: @escaping(String?) -> Void) {
        print("sessionID \(sessionID)")
        if let sessionID {
            guard let url = URL(string: serverURL + "user?session_key=\(sessionID)") else {
                completionHandler("Invalid URL")
                return
            }
            var request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else { return }
                guard let data else { return }
                if response.statusCode != 200 {
                    let errorMessage = String(data: data, encoding: .utf8)
                    print("error: \(errorMessage)")
                    completionHandler(errorMessage)
                }else{
                    do {
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: data)
                        self.profile.value = user
                        completionHandler(nil)
                    }catch let error {
                        print("Error decoding: \(error)")
                    }
                }
            }.resume()
        } else {
            profile.value = nil
            completionHandler("No session")
        }
    }
    
    func getUser(id: Int, completionHandler: @escaping(String?) -> Void){
        
    }
    
    func login(username: String, password: String, completionHandler: @escaping(String?) -> Void) {
        guard let url = URL(string: serverURL + "login?username=\(username)&password=\(password)") else {
            completionHandler("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            guard let data else { return }
            if response.statusCode == 200 {
                self.sessionID = String(data: data, encoding: .utf8)
                UserDefaults.standard.set(self.sessionID, forKey: "sessionID")
                completionHandler(nil)
            } else if response.statusCode == 401 {
                completionHandler("Wrong username or password")
            }
        }.resume()
    }
    
    func loadAvatar(source: URL, completionHandler: @escaping(Data?) -> Void) {
        
    }
    
    func loadNews(completionHandler: @escaping(String?) -> Void) {
        if let sessionID {
            print("Load news")
            guard let url = URL(string: serverURL + "/posts?session_key=\(sessionID)") else {
                completionHandler("Invalid URL")
                return
            }
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else { return }
                guard let data else { return }
                if response.statusCode == 200 {
                    do{
                        print(String(data: data, encoding: .utf8))
                        self.news.value = try JSONDecoder().decode([Post].self, from: data)
                        completionHandler(nil)
                    }catch let error{
                        completionHandler("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        } else {
            print("Cannot load news")
            news.value = nil
        }
    }
}
