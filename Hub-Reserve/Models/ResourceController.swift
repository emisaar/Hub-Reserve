//
//  ResourcesController.swift
//  Hub-Reserve
//
//  Created by Alejandro Diaz Villagomez on 05/10/22.
//

import Foundation

enum ResourceError:Error, LocalizedError{
    case itemNotFound
    case decodeError
}

class ResourceController{
    let baseURL = URL(string: "http://0.0.0.0:8000/api/resources/")!
    
    func fetchResources() async throws->Resources{
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                throw ResourceError.itemNotFound
            }
        let jsonDecoder = JSONDecoder()
        do{
            let resources = try jsonDecoder.decode(Resources.self, from: data)
            return resources
        }catch{
            throw ResourceError.decodeError
        }
        
        
    }
    /*
    func old_fetchReservas(completion: @escaping (Result<Resources, Error>) -> Void){
        let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data{
                do {
                    let resources = try? jsonDecoder.decode(Resources.self, from: data)
                    completion(.success(resources!))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
     */
}
