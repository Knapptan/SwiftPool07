//
//  main.swift
//  quest2
//
//  Created by Knapptan on 05.02.2024.
//

import Foundation

// Протокол сетевого сервиса
protocol IObjectService {
    func getObjectList(completion: @escaping (Result<FlightObject?, Error>) -> Void)
}

// Определение ошибок сети
enum NetworkError: Error {
    case badURL
    case invalidData
}

// Реализация протокола с использованием URLSession
class ObjectURLSessionService: IObjectService {
    let baseURL = "https://api.schiphol.nl/public-flights/flights"
    
    func getObjectList(completion: @escaping (Result<FlightObject?, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("v4", forHTTPHeaderField: "ResourceVersion")
            request.setValue("75a2cfab", forHTTPHeaderField: "app_id")
            request.setValue("e1e23dff52251314d5bcabe38b676d84", forHTTPHeaderField: "app_key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let objectList = try JSONDecoder().decode(FlightObject.self, from: data)
                completion(.success(objectList))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

func main() {
    let group = DispatchGroup()
    
    group.enter()
    Task {
        let objectService = ObjectURLSessionService()
        objectService.getObjectList { result in
            switch result {
            case .success(let objectList):
                if let objectList = objectList {
                    print("Received object list:")
                    print(objectList)
                } else {
                    print("Received nil object list")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
            group.leave()
        }
    }
    
    group.wait()
}


main()
