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

struct getReservasRequestBody: Codable {
    let Authorization: String
}

struct addReservaRequestBody: Codable {
    var resource: Int
    var start: String
    var finish: String
    var description: String
    var comments: String
    var id_before_update: Int?
    var changed_by_admin: Bool
    var changed_by_user: Bool
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
        
        //        var request = URLRequest(url: baseURL)
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.addValue(token, forHTTPHeaderField: "Authorization")
        //        print("\n\n\n\nREQUEST")
        //        for s in request.allHTTPHeaderFields!{
        //            print(s.0, s.1)
        //        }
        
        let body = getResourcesRequestBody(Authorization: token)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    func addReserva(token: String, resource: Int, start: String, finish: String, description: String, comments: String, id_before_update: Int, changed_by_admin: Bool, changed_by_user: Bool) async throws -> Void {
        //        let baseString = "http://0.0.0.0:8000/api/reservations/"
        let baseURL = URL(string: "http://0.0.0.0:8000/api/reservations/")!
        //        var request = URLRequest(url: baseURL)
        //        request.httpMethod = "POST"
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //
        let body = addReservaRequestBody(resource: resource, start: start, finish: finish, description: description, comments: comments, id_before_update: id_before_update, changed_by_admin: changed_by_admin, changed_by_user: changed_by_user)
        
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
    
    func getReservas(token: String) async throws -> Reservas {
        //        "https://hubreserve.systems/api/reservations/"
        let baseURL = URL(string: "http://0.0.0.0:8000/api/reservations/")!
        
        //        var request = URLRequest(url: baseURL)
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.addValue(token, forHTTPHeaderField: "Authorization")
        //        print("\n\n\n\nREQUEST")
        //        for s in request.allHTTPHeaderFields!{
        //            print(s.0, s.1)
        //        }
        
        let body = getResourcesRequestBody(Authorization: token)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
}
