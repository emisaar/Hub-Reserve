//
//  WebService.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 03/10/22.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct LoginRequestBody: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String?
    let jwt: String?
    let user_type: Int?
}

struct ResourceRequestBody: Codable {
    let jwt: String
}

struct ResourceResponse: Codable{
    var resource_type:String?
    var name:String?
    var description:String?
    var location:Int?
    var active:Bool?
}

class WebService {
    func login(email: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        guard let url = URL(string: "http://0.0.0.0:8000/api/login/") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = LoginRequestBody(email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
            else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            print("WEBSERVICE")
            print(loginResponse)
            
            guard let token = loginResponse.jwt else {
                completion(.failure(.custom(errorMessage: "Token")))
                return
            }
            
            completion(.success(token))
        }.resume()
    }
    
    func resources(jwt: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        guard let url = URL(string: "http://0.0.0.0:8000/api/resources/") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = ResourceRequestBody(jwt: jwt)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            
            guard let resourceResponse = try? JSONDecoder().decode(ResourceResponse.self, from: data)
            else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            print("WEBSERVICE")
            print(resourceResponse)
            
            guard let resourceName = resourceResponse.name else {
                completion(.failure(.custom(errorMessage: "Token")))
                return
            }
            guard let resourceType = resourceResponse.resource_type else {
                completion(.failure(.custom(errorMessage: "Token")))
                return
            }
            guard let resourceDescription = resourceResponse.description else {
                completion(.failure(.custom(errorMessage: "Token")))
                return
            }
            guard let resourceLocation = resourceResponse.location else {
                completion(.failure(.custom(errorMessage: "Token")))
                return
            }
            guard let resourceStatus = resourceResponse.active else {
                completion(.failure(.custom(errorMessage: "Token")))
                return
            }
            
            completion(.success(resourceName))
            completion(.success(resourceType))
            completion(.success(resourceDescription))
            completion(.success(String(resourceLocation)))
            completion(.success(String(resourceStatus)))
        }.resume()
    }
}
