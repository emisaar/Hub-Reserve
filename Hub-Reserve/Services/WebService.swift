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

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
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
        guard let url = URL(string: "https://hubreserve.systems/api/login/") else {
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
    
    func getResources(token: String) async throws -> Resources {
        let baseURL = URL(string: "https://hubreserve.systems/api/resources/")!
    
        var request = URLRequest(url: baseURL)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        let jsonDecoder = JSONDecoder()
        do {
            let reservas = try jsonDecoder.decode(Resources.self, from: data)
            return reservas
        }catch{
            throw NetworkError.decodingError
        }
    }
}
