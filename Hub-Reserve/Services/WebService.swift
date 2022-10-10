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
    let id: Int?
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

struct editReservaRequestBody: Codable {
    var start: String
    var finish: String
    var description: String
    var comments: String
}

struct ResourceResponse: Codable {
    var resource_type:String?
    var name:String?
    var description:String?
    var location:Int?
    var active:Bool?
}

struct UserRequestBody: Codable {
    var name: String
    var lastname: String
    var email: String
    var password: String
    var organization: String
}

struct UserDeleteRequestBody: Codable {
    var Authorization: String
}

struct UserChangePwdRequestBody: Codable {
    var email: String
    var password: String
}

struct UserChangePwdResponse: Codable {
    var is_correct: Bool?
}

class WebService {
    func login(email: String, password: String, completion: @escaping (Result<(String, Int), AuthenticationError>) -> Void) {
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
            
            guard let userID = loginResponse.id else {
                completion(.failure(.custom(errorMessage: "User ID")))
                return
            }
            //let tuple = Result.success(token, userID)
            //completion(.success(tuple))
            completion(.success((token, userID)))
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
              httpResponse.statusCode == 201 else {
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
    
    func editReserva(id: String, token: String, start: String, finish: String, description: String, comments: String) async throws -> Void {
        //        let baseString = "http://0.0.0.0:8000/api/reservations/"
        let baseURL = URL(string: "http://0.0.0.0:8000/api/reservation/\(id)/")!
        //        var request = URLRequest(url: baseURL)
        //        request.httpMethod = "POST"
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //
        let body = editReservaRequestBody(start: start, finish: finish, description: description, comments: comments)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "PUT"
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
              httpResponse.statusCode == 201 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nTODO BIEN")
    }

    
    func deleteReserva(id: Int, token: String) async throws -> Void {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            print("WRONG ID")
            return
        }
        var ep = "http://0.0.0.0:8000/api/reservation/\(id)/"
        let baseURL = URL(string: ep)!
        
        //--------------------------------
        print("PRUEBA")
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = UserDeleteRequestBody(Authorization: token)
        
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
              httpResponse.statusCode == 204 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nTODO BIEN")
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
        let defaults = UserDefaults.standard
        guard let userId = defaults.string(forKey: "userId") else {
            print("WRONG ID")
            return
        }
        var ep = "http://0.0.0.0:8000/api/user/" + userId + "/"
        let baseURL = URL(string: ep)!
        
        //--------------------------------
        print("PRUEBA")
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = UserDeleteRequestBody(Authorization: token)
        
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
    
//    func changePassword(email: String, password: String) async throws -> Bool{
//        let baseURL = URL(string: "http://0.0.0.0:8000/api/user/validatePWD/")!
//
//        let body = UserChangePwdRequestBody(email: email, password: password)
//
//        var request = URLRequest(url: baseURL)
//        request.httpMethod = "POST"
//
//        print("\n\n\nBODY BEFORE")
//        print(body)
//        request.httpBody = try? JSONEncoder().encode(body)
//        print("\n\n\nBODY")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//        print(String(data: data, encoding: .utf8))
//        print(response)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw NetworkError.noData
//        }
//
//        print("\n\n\nTODO BIEN")
//
//        do {
//            let is_valid = try JSONDecoder().decode(UserChangePwdResponse.self, from: data)
//            print("BIEN")
//            print(is_valid)
//            return is_valid.is_valid ?? false
//        }catch{
//            print("NOOO")
//            throw NetworkError.decodingError
//        }
//    }

func boolCheckPassword(email: String, password: String) async throws -> Bool{
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            print("WRONG TOKEN CHANGE")
            return false
        }
        
        let baseURL = URL(string: "http://0.0.0.0:8000/api/user/validatePWD/")!
        
        let body = UserChangePwdRequestBody(email: email, password: password)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        print("\n\n\nBODY BEFORE")
        print(body)
        request.httpBody = try? JSONEncoder().encode(body)
        print("\n\n\nBODY")
        
        print(token)
        print("PRUEBA\n")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nTODO BIEN")
        /*
        guard let boolPwd = JSONDecoder().decode(UserChangePwdResponse.self, from: data)
        */
        do {
            let changePwd = try JSONDecoder().decode(UserChangePwdResponse.self, from: data)
            print("is_valid!!!")
            print(changePwd.is_correct)
            return changePwd.is_correct ?? false
        }catch{
            print("NOOO")
            throw NetworkError.decodingError
        }
    }
}
