//
//  main.swift
//  quest1
//
//  Created by Knapptan on 03.02.2024.
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
