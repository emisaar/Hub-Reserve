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

struct addFavoritesRequestBody: Codable {
    let resource: Int
}

struct deleteFavoritesRequestBody: Codable {
    let resource: Int
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

struct UserChangeName: Codable {
    var name: String
    var lastname: String
}

struct UserRecoveryPwdRequestBody: Codable{
    var email: String
}

class WebService {
    func login(email: String, password: String, completion: @escaping (Result<(String, Int), AuthenticationError>) -> Void) {
//        "https://hubreserve.systems/api/login/"
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
            
            guard let userID = loginResponse.id else {
                completion(.failure(.custom(errorMessage: "User ID")))
                return
            }
            //let tuple = Result.success(token, userID)
            //completion(.success(tuple))
            completion(.success((token, userID)))
        }.resume()
    }
    
    func logOut(token: String) async throws -> Void{
        
        let baseURL = URL(string: "https://hubreserve.systems/api/logout/")!
//        let baseURL = URL(string: "http://0.0.0.0:8000/api/logout/")!
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        print("Headers")
        for s in request.allHTTPHeaderFields!{
            print(s.0, s.1)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nLOGOUT CORRECTO")
    }
    
    func getFavorites(token: String) async throws -> Favorites {
        //        "https://hubreserve.systems/api/favourites/"
        let baseURL = URL(string: "https://hubreserve.systems/api/favourites/")!
        
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
            let favoritos = try JSONDecoder().decode(Favorites.self, from: data)
            print("BIEN")
            print(favoritos)
            return favoritos
        }catch{
            print("NOOO")
            throw NetworkError.decodingError
        }
    }
    
    func addFavorites(token: String, resource: Int) async throws -> Void {
        //        "https://hubreserve.systems/api/favourites/"
        let baseURL = URL(string: "https://hubreserve.systems/api/favourites/")!
        let body = addFavoritesRequestBody(resource: resource)
        
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
    
    func deleteFavorites(id: Int) async throws -> Void {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            print("WRONG ID")
            return
        }
        
        let baseURL = URL(string: "https://hubreserve.systems/api/favourites/")!
        
        //--------------------------------
        print("PRUEBA")
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let body = deleteFavoritesRequestBody(resource: id)
        
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
    
    func getResources(token: String) async throws -> Resources {
        //        "https://hubreserve.systems/api/resources/"
        let baseURL = URL(string: "https://hubreserve.systems/api/resources/")!
        
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
        let baseURL = URL(string: "https://hubreserve.systems/api/reservations/")!
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
        let baseURL = URL(string: "https://hubreserve.systems/api/reservations/")!
        
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
        print("ID RUTA")
        print(id)
        let baseURL = URL(string: "https://hubreserve.systems/api/reservation/\(id)/")!
        //        var request = URLRequest(url: baseURL)
        //        request.httpMethod = "POST"
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //
        let body = editReservaRequestBody(start: start, finish: finish, description: description, comments: comments)
        
        print(body)
        
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
        var ep = "https://hubreserve.systems/api/reservation/\(id)/"
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
        
        let baseURL = URL(string: "https://hubreserve.systems/api/users/")!
        
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
        var ep = "https://hubreserve.systems/api/user/" + userId + "/"
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
    
    func changePassword(email: String, password: String) async throws -> Bool{
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            print("WRONG TOKEN CHANGE")
            return false
        }
        //Change URL
        let baseURL = URL(string: "https://hubreserve.systems/api/userChangePWD/")!

        let body = UserChangePwdRequestBody(email:email, password: password)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"

        print("\n\n\nBODY BEFORE")
        print(body)
        request.httpBody = try? JSONEncoder().encode(body)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        print("\n\n\nBODY")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
        print(response)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }

        print("\n\n\nTODO BIEN")
        return true
    }


    func boolCheckPassword(email: String, password: String) async throws -> Bool{
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            print("WRONG TOKEN CHANGE")
            return false
        }
        
        let baseURL = URL(string: "https://hubreserve.systems/api/user/validatePWD/")!
        
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
    
    func getUser(token: String, id: String) async throws -> User {
        let baseURL = URL(string: "https://hubreserve.systems/api/user/\(id)/")!
        
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
//        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        print("\n\n\nTODO BIEN")
        
        
        do {
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            var id = 0
            var name = ""
            var lastname = ""
            if let dictionary = jsonData as? [String: Any] {
                if let nestedDictionary = dictionary["user"] as? [String: Any] {
                    for (key, value) in nestedDictionary {
                        // access all key / value pairs in dictionary
                        if (key == "id") {
                            id = value as! Int
                        }
                        
                        if (key == "name") {
                            name = value as! String
                        }
                        
                        if (key == "lastname") {
                            lastname = value as! String
                        }
                    }
                }
            }
            let user = User(id: id, name: name, lastname: lastname)
            print("BIEN")
            print(user)
            
            let defaults = UserDefaults.standard
            defaults.setValue(user.name, forKey: "username")
            defaults.setValue(user.lastname, forKey: "lastname")
            
            return user
        }catch{
            print("NOOO")
            throw NetworkError.decodingError
        }
    }
    
    func changeUserName(name: String, lastname: String) async throws -> Void{
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            print("WRONG TOKEN")
            return
        }
        guard let userId = defaults.string(forKey: "userId") else {
            print("WRONG ID")
            return
        }
        //Change URL
        let baseURL = URL(string: "https://hubreserve.systems/api/user/\(userId)/")!

        let body = UserChangeName(name: name, lastname: lastname)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "PUT"
        request.addValue(token, forHTTPHeaderField: "Authorization")

        print("\n\n\nBODY BEFORE")
        print(body)
        request.httpBody = try? JSONEncoder().encode(body)
        print("\n\n\nBODY")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
        print(response)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }

        print("\n\n\nTODO BIEN")
    }
    
    func RecoveryPWD(email: String) async throws -> Void{
        //Change URL
        let baseURL = URL(string: "https://hubreserve.systems/api/sendRecoveryEmail/")!

        let body = UserRecoveryPwdRequestBody(email:email)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"

        print("\n\n\nBODY BEFORE")
        print(body)
        request.httpBody = try? JSONEncoder().encode(body)
        print("\n\n\nBODY")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
        print(response)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw NetworkError.noData
        }

        print("\n\n\nTODO BIEN")
        return 
    }
    
    func getStats(token: String) async throws -> Stats{
        let baseURL = URL(string: "https://hubreserve.systems/api/stats/")!

        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
        print(response)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        do {
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            var last_hardware = ""
            var last_software = ""
            var last_room = ""
            var total_time = 0.0
            var most_used = ""

            if let dictionary = jsonData as? [String: Any] {
                for (key, value) in dictionary {
                    // access all key / value pairs in dictionary
                    if (key == "last_hardware") {
                        last_hardware = value as! String
                    }
                    
                    if (key == "last_software") {
                        last_software = value as! String
                    }
                    
                    if (key == "last_room") {
                        last_room = value as! String
                    }
                    
                    if (key == "total_time") {
                        total_time = value as! Double
                    }
                    
                    if (key == "most_used") {
                        most_used = value as! String
                    }
                }
            }
            
            let stat = Stats(last_hardware: last_hardware, last_software: last_software, last_room: last_room, total_time: total_time, most_used: most_used)
            
            let defaults = UserDefaults.standard
            defaults.setValue(stat.last_hardware, forKey: "last_hardware")
            defaults.setValue(stat.last_software, forKey: "last_software")
            defaults.setValue(stat.last_room, forKey: "last_room")
            defaults.setValue(stat.total_time, forKey: "total_time")
            defaults.setValue(stat.most_used, forKey: "most_used")
            
            print("BIEN")
            print(last_hardware)
            print(last_software)
            print(last_room)
            print(total_time)
            print(most_used)
            print(stat)
            
            return stat
        }catch{
            print("NOOO")
            throw NetworkError.decodingError
        }
    }
}
