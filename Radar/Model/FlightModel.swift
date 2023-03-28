//
//  FlightModel.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

// MARK: - Flights
struct Flights: Decodable {
    let result: Result
}

// MARK: - Result
struct Result: Decodable {
    let records: [Record]
    var total: Int
}

// MARK: - Record
struct Record: Decodable {
    let id: Int
    let flightLetter: String
    let flightNumber: String
    let airlinesName: String
    let scheduledTime: String
    let currentTime: String
    let kind: String
    let airportCode:String
    let chloc1D: String
    let cityHe: String
    let cityEn: String
    let countryHe: String
    let countryEn: String
    let terminal: String
    let counterArea: String?
    let chckzn: String?
    let statusEn: String
    let statusHe: String
    
    
    func city(lang: String) -> String{
        if lang == "en"{
            return cityEn
        } else if lang == "he"{
            return cityHe
        }  else if lang == "all"{
            return cityHe + cityEn
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    func status(lang: String) -> String {
        if lang == "en"{
            return statusEn
        } else if lang == "he"{
            return statusHe
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var flightLetterNumber: String {
        return ("\(flightLetter) \(flightNumber)")
    }
    
    var flightLetterNumberSpace: String {
        return (flightLetter+flightNumber)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case flightLetter = "CHOPER"
        case flightNumber = "CHFLTN"
        case airlinesName = "CHOPERD"
        case scheduledTime = "CHSTOL"
        case currentTime = "CHPTOL"
        case kind = "CHAORD"
        case airportCode = "CHLOC1"
        case chloc1D = "CHLOC1D"
        case cityHe = "CHLOC1TH"
        case cityEn = "CHLOC1T"
        case countryHe = "CHLOC1CH"
        case countryEn = "CHLOCCT"
        case terminal = "CHTERM"
        case counterArea = "CHCINT"
        case chckzn = "CHCKZN"
        case statusEn = "CHRMINE"
        case statusHe = "CHRMINH"
    }
}
