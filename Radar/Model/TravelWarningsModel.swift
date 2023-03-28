//
//  TravelWarningsModel.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

// MARK: - TravelWarnings
struct TravelWarnings: Decodable {
    let result: TravelWarningsResulte
}

// MARK: - TravelWarningsResulte
struct TravelWarningsResulte: Decodable {
    let records: [TravelWarningRecored]
    var total: Int
}

// MARK: - TravelWarningRecored
struct TravelWarningRecored: Decodable {
    let id: Int
    let continent: String
    let country: String
    let recommendations: String
    let details: String
    let logo: String
    let date: String?
    let office: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case continent
        case country
        case recommendations
        case details
        case logo
        case date
        case office = "משרד"
    }
}
