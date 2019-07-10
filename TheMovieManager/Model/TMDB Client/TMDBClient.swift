//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "bdddad458636a0f190525a289c764e96"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        case getRequestToken
        case login
        
        
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login: return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(MovieResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
    
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url){data, response, error in
            guard let data = data else{
                 print("=====> no data")
                
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(RequestTokenResponse.self, from: data)
                print("responseObject ========> ")
                print( responseObject)
                
                completion(responseObject.success, nil)
                self.Auth.requestToken = responseObject.requestToken
                
                print("getRequestToken ========> ")
                print(Auth.requestToken)
                
            }catch{
                
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    class func loging(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(username: username, password: password, requestToken: self.Auth.requestToken)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
           
            guard let data = data else {
                completion(false, error)
                print("post error ====>")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(RequestTokenResponse.self, from: data)
                print("login post responseObject =====>")
                print(responseObject)
                Auth.requestToken = responseObject.requestToken
                print("post success ====>")
                completion(true, nil)
            }catch{
                completion(false, error)
                
                print("post parsing error ====>")
                print(error)
                print("post parsing error print data ====>")
//                print(try! JSONSerialization.jsonObject(with: data, options: []))
            }
        }
        
        task.resume()
        
    }
    
    
    
    
}
