//
//  main.swift
//  quest3
//
//  Created by Knapptan on 05.02.2024.
//

import Foundation
import Alamofire

// Протокол сетевого сервиса
protocol IObjectService {
    func getObjectList(completion: @escaping (Result<FlightObject?, Error>) -> Void)
}

// Определение ошибок сети
enum NetworkError: Error {
    case badURL
    case invalidData
    case requestFailed
}

// Реализация протокола с использованием Alamofire
class ObjectAlamofireService: IObjectService {
    let baseURL = "https://api.schiphol.nl/public-flights/flights"
    private let APP_ID = "75a2cfab"
    private let APP_KEY = "e1e23dff52251314d5bcabe38b676d84"
    
    func getObjectList(completion: @escaping (Result<FlightObject?, Error>) -> Void) {
        let head:HTTPHeaders = ["Accept":"application/json", "ResourceVersion": "v4", "app_id": APP_ID, "app_key":APP_KEY]
        AF.request(baseURL, method: .get, headers: head)
            .responseDecodable(of: FlightObject.self){ response in
                switch response.result {
                case .success(let flightObject):
//                    let content = String(data: flightObject, encoding: .utf8)
//                    print (flightObject)
//                    completion(.success(objectList))
                    completion(.success(flightObject.self))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(NetworkError.requestFailed))
                }
            }
    }
}

// Модель для ответа сервера
struct FlightObjectResponse: Decodable {
    let flights: [FlightObject]
}


func main() async {
    let group = DispatchGroup()
    
    group.enter()
    Task {
        let objectService = ObjectAlamofireService()
        objectService.getObjectList { result in
            switch result {
            case .success(let objectList):
                if let objectList = objectList {
                    print("Received object list:")
                    print(objectList.self)
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

await main()
//let seconds = 4.0
//try await Task.sleep(nanoseconds: UInt64(seconds * Double(NSEC_PER_SEC)))

