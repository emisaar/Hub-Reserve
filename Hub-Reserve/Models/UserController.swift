//
//  User.swift
//  retoVersionBeta
//
//  Created by molina on 29/09/22.
//

import Foundation

enum UserError:Error, LocalizedError{
    case itemNotFound
    case decodeError
}

class UserController {
    let baseURL = URL(string: "http://0.0.0.0:8000/api/login/")!
    
    func fetchUsers() async throws->Users {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                throw UserError.itemNotFound
            }
        let jsonDecoder = JSONDecoder()
        do{
            let users = try jsonDecoder.decode(Users.self, from: data)
            print(jsonDecoder)
            return users
        }catch{
            throw UserError.decodeError
        }
    }
}

