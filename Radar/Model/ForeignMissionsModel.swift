//
//  ForeignMissionsModel.swift
//  Radar
//
//  Created by Oran on 02/08/2022.
//

import UIKit

// MARK: - Welcome
struct ForeignMissions: Decodable {
    let result: ForeignMissionsResult
}

// MARK: - Result
struct ForeignMissionsResult: Decodable {
    let records: [ForeignMissionsRecord]
    let total:Int
}

// MARK: - Record
struct ForeignMissionsRecord: Decodable {
    let id: Int?
    let countryEn: String?
    let countryHe: String?
    let shem_ntz: String?
    let statusEn: String?
    let statusHe: String?
    let addressEn: String?
    let addressHe: String?
    let tel: String?
    let fax: String?
    
    func country(lang: String) -> String{
        if lang == "en" {
            return countryEn!
        } else{
            return countryHe!
        }
    }
    
    func status(lang: String) -> String{
        if lang == "en" {
            return statusEn!
        } else{
            return statusHe!
        }
    }
    
    func address(lang: String) -> String{
        if lang == "en" {
            return addressEn!
        } else{
            return addressHe!
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case countryEn = "shem_mdn_a"
        case countryHe = "shem_mdn"
        case shem_ntz
        case statusEn = "maamad_a"
        case statusHe = "maamad"
        case addressEn = "addrs"
        case addressHe = "address"
        case tel
        case fax
    }
}
