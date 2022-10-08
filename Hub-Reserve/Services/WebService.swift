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

struct getResourcesRequestBody: Codable {
    let Authorization: String
}

struct ResourceResponse: Codable{
    var resource_type:String?
    var name:String?
    var description:String?
    var location:Int?
    var active:Bool?
}

struct UserRequestBody: Codable{
    var name: String
    var lastname: String
    var email: String
    var password: String
    var organization: String
}

struct UserDeleteRequestBody: Codable{
    var delete: Bool
}

class WebService {
    func login(email: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
//        "https://hubreserve.systems/api/login/"
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
    
    func getResources(token: String) async throws -> Resources {
//        "https://hubreserve.systems/api/resources/"
        let baseURL = URL(string: "http://0.0.0.0:8000/api/resources/")!
        
        let body = getResourcesRequestBody(Authorization: token)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        print("\n\n\nBODY BEFORE")
        print(body)
        request.httpBody = try? JSONEncoder().encode(body)
            
        print("\n\n\nBODY")
        print(request.httpBody)
        
        for s in request.allHTTPHeaderFields!{
            print(s.0, s.1)
        }
        
        //--------------------
        let (data, response) = try await URLSession.shared.data(from: baseURL)
            print(String(data: data, encoding: .utf8))
            print(response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nTODO BIEN")
        
        do {
           let reservas = try JSONDecoder().decode(Resources.self, from: data)
            print("BIEN")
            print(reservas)
            return reservas
        }catch{
            print("NOOO")
            throw NetworkError.decodingError
        }
    }
    
    func getReservas(token: String) async throws -> Reservas {
//        "https://hubreserve.systems/api/resources/"
        let baseURL = URL(string: "http://0.0.0.0:8000/api/reservations/")!
        
        let body = getResourcesRequestBody(Authorization: token)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        print("\n\n\nBODY BEFORE")
        print(body)
        request.httpBody = try? JSONEncoder().encode(body)
            
        print("\n\n\nBODY")
        print(request.httpBody)
        
        for s in request.allHTTPHeaderFields!{
            print(s.0, s.1)
        }
        
        //--------------------
        let (data, response) = try await URLSession.shared.data(from: baseURL)
            print(String(data: data, encoding: .utf8))
            print(response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nTODO BIEN")
        
        do {
           let reservas = try JSONDecoder().decode(Reservas.self, from: data)
            print("BIEN")
            print(reservas)
            return reservas
        }catch{
            print("NOOO")
            throw NetworkError.decodingError
        }
    }
    
    func registerUser(name: String, lastname: String, email: String, password: String, organization: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        
        let baseURL = URL(string: "http://0.0.0.0:8000/api/users/")!
        
        let body = UserRequestBody(name: name, lastname: lastname, email: email, password: password, organization: organization)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        print("\n\n\nBODY BEFORE")
        print(body)
        request.httpBody = try? JSONEncoder().encode(body)
        print("\n\n\nBODY")
        
        print(request.httpBody)
        
//        for s in request.allHTTPHeaderFields!{
//            print(s.0, s.1)
//        }
        
        //--------------------
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else{
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 201 else {
                completion(.failure(.custom(errorMessage: "Bad request")))
                return
            }
            completion(.success("Todo bien"))
        }.resume()
    }
    
    
    func deleteUser(token: String) async throws -> Void {
        
        let baseURL = URL(string: "http://0.0.0.0:8000/api/users/")!
        
        let body = UserDeleteRequestBody(delete: true)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        print("BODY")
        print(body)
        
        print("Headers")
        for s in request.allHTTPHeaderFields!{
            print(s.0, s.1)
        }
        
        //--------------------
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nTODO BIEN")
    }
}
