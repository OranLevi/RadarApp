//
//  EmbassiesModel.swift
//  Radar
//
//  Created by Oran on 01/08/2022.
//

import UIKit

// MARK: - Embassies
struct Embassies: Decodable {
    let result: EmbassiesResult
}

// MARK: - Result
struct EmbassiesResult: Decodable {
    let records: [EmbassiesRecord]
    let total:Int
}

// MARK: - Record
struct EmbassiesRecord: Decodable {
    let id: Int?
    let countryEn: String?
    let countryHe: String?
    let continentEn: String?
    let continentHe: String?
    let shemNtzA: String?
    let statusEn: String?
    let statusHe: String?
    let addressEn: String?
    let addressHe: String?
    let hours: String?
    let email: String?
    let tel: String?
    let fax: String?
    let visaToMdn: String?
    let visaToIsrael: String?
    let atar: String?
    
    func country(lang: String) -> String {
        if lang == "en"{
            return countryEn!
        } else {
            return countryHe!
        }
    }
    
    func continent(lang: String) -> String {
        if lang == "en"{
            return continentEn!
        } else {
            return continentHe!
        }
    }
    
    func status(lang: String) -> String {
        if lang == "en"{
            return statusEn!
        } else {
            return statusHe!
        }
    }
    
    func address(lang: String) -> String {
        if lang == "en"{
            return addressEn!
        } else {
            return addressHe!
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case countryEn = "shem_mdn_a"
        case countryHe = "shem_mdn"
        case continentEn = "ybsht_a"
        case continentHe = "ybsht"
        case shemNtzA = "shem_ntz_a"
        case statusEn = "maamad_a"
        case statusHe = "maamad"
        case addressEn = "Addrs"
        case addressHe = "Address"
        case hours = "Kabala"
        case email
        case tel
        case fax
        case visaToMdn = "visa_to_mdn"
        case visaToIsrael = "visa_to_Israel"
        case atar = "Atar"
    }
}
