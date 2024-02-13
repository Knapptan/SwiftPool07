//
//  alomafireStructs.swift
//  quest3
//
//  Created by Knapptan on 05.02.2024.
//

import Foundation

struct FlightObject: Codable {
    let flights: [Flight]
}

// MARK: - Flight
struct Flight: Codable {
    let lastUpdatedAt: String
    let actualLandingTime, actualOffBlockTime, aircraftRegistration: String?
    let aircraftType: AircraftType
    let baggageClaim: BaggageClaim?
    let checkinAllocations: CheckinAllocations?
    let codeshares: Codeshares?
    let estimatedLandingTime: String?
    let expectedTimeBoarding, expectedTimeGateClosing, expectedTimeGateOpen: JSONNull?
    let expectedTimeOnBelt, expectedSecurityFilter: String?
    let flightDirection: FlightDirection
    let flightName: String
    let flightNumber: Int
    let gate: String?
    let pier: FlightDirection?
    let id: String
    let isOperationalFlight: Bool
    let mainFlight, prefixIATA, prefixICAO: String
    let airlineCode: Int
    let publicEstimatedOffBlockTime: String?
    let publicFlightState: PublicFlightState
    let route: Route?
    let scheduleDateTime, scheduleDate, scheduleTime: String
    let serviceType: ServiceType?
    let terminal: Int?
    let transferPositions: JSONNull?
    let schemaVersion: String
}

// MARK: - AircraftType
struct AircraftType: Codable {
    let iataMain, iataSub: String
}

// MARK: - BaggageClaim
struct BaggageClaim: Codable {
    let belts: [String]
}

// MARK: - CheckinAllocations
struct CheckinAllocations: Codable {
    let checkinAllocations: [CheckinAllocation]
    let remarks: JSONNull?
}

// MARK: - CheckinAllocation
struct CheckinAllocation: Codable {
    let endTime: String
    let rows: Rows
    let startTime: String
}

// MARK: - Rows
struct Rows: Codable {
    let rows: [Row]
}

// MARK: - Row
struct Row: Codable {
    let position: String
    let desks: Desks
}

// MARK: - Desks
struct Desks: Codable {
    let desks: [Desk]
}

// MARK: - Desk
struct Desk: Codable {
    let checkinClass: CheckinClass?
    let position: Int
}

// MARK: - CheckinClass
struct CheckinClass: Codable {
    let code: Code
    let description: Description
}

enum Code: String, Codable {
    case b = "B"
    case s = "S"
}

enum Description: String, Codable {
    case baggageDropOff = "Baggage drop-off"
    case serviceDesk = "Service desk"
}

// MARK: - Codeshares
struct Codeshares: Codable {
    let codeshares: [String]
}

enum FlightDirection: String, Codable {
    case a = "A"
    case d = "D"
}

// MARK: - PublicFlightState
struct PublicFlightState: Codable {
    let flightStates: [FlightState]
}

enum FlightState: String, Codable {
    case arr = "ARR"
    case dep = "DEP"
    case exp = "EXP"
    case lnd = "LND"
    case sch = "SCH"
}

// MARK: - Route
struct Route: Codable {
    let destinations: [String]?
    let eu: Eu?
    let visa: Bool?
}

enum Eu: String, Codable {
    case n = "N"
    case s = "S"
    case e = "E"
}

enum ServiceType: String, Codable {
    case c = "C"
    case f = "F"
    case j = "J"
    case p = "P"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(256)
    }

    public required init() {}
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

