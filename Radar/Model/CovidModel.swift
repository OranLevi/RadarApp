//
//  CovidModel.swift
//  Radar
//
//  Created by Oran on 30/07/2022.
//

import UIKit

var service = Service.shard

// MARK: - Welcome
struct Covid: Decodable {
    
    init(from decoder: Decoder) throws {
        for key in CodingKeys.allCases {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let global = try? container.decode(Global.self, forKey: key) {
                service.dataArrayCovidAll.append(global)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case afghanistan = "Afghanistan"
        case albania = "Albania"
        case algeria = "Algeria"
        case andorra = "Andorra"
        case angola = "Angola"
        case antarctica = "Antarctica"
        case antiguaAndBarbuda = "Antigua and Barbuda"
        case argentina = "Argentina"
        case armenia = "Armenia"
        case australia = "Australia"
        case austria = "Austria"
        case azerbaijan = "Azerbaijan"
        case bahamas = "Bahamas"
        case bahrain = "Bahrain"
        case bangladesh = "Bangladesh"
        case barbados = "Barbados"
        case belarus = "Belarus"
        case belgium = "Belgium"
        case belize = "Belize"
        case benin = "Benin"
        case bhutan = "Bhutan"
        case bolivia = "Bolivia"
        case bosniaAndHerzegovina = "Bosnia and Herzegovina"
        case botswana = "Botswana"
        case brazil = "Brazil"
        case brunei = "Brunei"
        case bulgaria = "Bulgaria"
        case burkinaFaso = "Burkina Faso"
        case burma = "Burma"
        case burundi = "Burundi"
        case caboVerde = "Cabo Verde"
        case cambodia = "Cambodia"
        case cameroon = "Cameroon"
        case canada = "Canada"
        case centralAfricanRepublic = "Central African Republic"
        case chad = "Chad"
        case chile = "Chile"
        case china = "China"
        case colombia = "Colombia"
        case comoros = "Comoros"
        case congoBrazzaville = "Congo (Brazzaville)"
        case congoKinshasa = "Congo (Kinshasa)"
        case costaRica = "Costa Rica"
        case coteDIvoire = "Cote d'Ivoire"
        case croatia = "Croatia"
        case cuba = "Cuba"
        case cyprus = "Cyprus"
        case czechia = "Czechia"
        case denmark = "Denmark"
        case diamondPrincess = "Diamond Princess"
        case djibouti = "Djibouti"
        case dominica = "Dominica"
        case dominicanRepublic = "Dominican Republic"
        case ecuador = "Ecuador"
        case egypt = "Egypt"
        case elSalvador = "El Salvador"
        case equatorialGuinea = "Equatorial Guinea"
        case eritrea = "Eritrea"
        case estonia = "Estonia"
        case eswatini = "Eswatini"
        case ethiopia = "Ethiopia"
        case fiji = "Fiji"
        case finland = "Finland"
        case france = "France"
        case gabon = "Gabon"
        case gambia = "Gambia"
        case georgia = "Georgia"
        case germany = "Germany"
        case ghana = "Ghana"
        case greece = "Greece"
        case grenada = "Grenada"
        case guatemala = "Guatemala"
        case guinea = "Guinea"
        case guineaBissau = "Guinea-Bissau"
        case guyana = "Guyana"
        case haiti = "Haiti"
        case holySee = "Holy See"
        case honduras = "Honduras"
        case hungary = "Hungary"
        case iceland = "Iceland"
        case india = "India"
        case indonesia = "Indonesia"
        case iran = "Iran"
        case iraq = "Iraq"
        case ireland = "Ireland"
        case israel = "Israel"
        case italy = "Italy"
        case jamaica = "Jamaica"
        case japan = "Japan"
        case jordan = "Jordan"
        case kazakhstan = "Kazakhstan"
        case kenya = "Kenya"
        case kiribati = "Kiribati"
        case koreaNorth = "Korea, North"
        case koreaSouth = "Korea, South"
        case kosovo = "Kosovo"
        case kuwait = "Kuwait"
        case kyrgyzstan = "Kyrgyzstan"
        case laos = "Laos"
        case latvia = "Latvia"
        case lebanon = "Lebanon"
        case lesotho = "Lesotho"
        case liberia = "Liberia"
        case libya = "Libya"
        case liechtenstein = "Liechtenstein"
        case lithuania = "Lithuania"
        case luxembourg = "Luxembourg"
        case msZaandam = "MS Zaandam"
        case madagascar = "Madagascar"
        case malawi = "Malawi"
        case malaysia = "Malaysia"
        case maldives = "Maldives"
        case mali = "Mali"
        case malta = "Malta"
        case marshallIslands = "Marshall Islands"
        case mauritania = "Mauritania"
        case mauritius = "Mauritius"
        case mexico = "Mexico"
        case micronesia = "Micronesia"
        case moldova = "Moldova"
        case monaco = "Monaco"
        case mongolia = "Mongolia"
        case montenegro = "Montenegro"
        case morocco = "Morocco"
        case mozambique = "Mozambique"
        case namibia = "Namibia"
        case nepal = "Nepal"
        case netherlands = "Netherlands"
        case newZealand = "New Zealand"
        case nicaragua = "Nicaragua"
        case niger = "Niger"
        case nigeria = "Nigeria"
        case northMacedonia = "North Macedonia"
        case norway = "Norway"
        case oman = "Oman"
        case pakistan = "Pakistan"
        case palau = "Palau"
        case panama = "Panama"
        case papuaNewGuinea = "Papua New Guinea"
        case paraguay = "Paraguay"
        case peru = "Peru"
        case philippines = "Philippines"
        case poland = "Poland"
        case portugal = "Portugal"
        case qatar = "Qatar"
        case romania = "Romania"
        case russia = "Russia"
        case rwanda = "Rwanda"
        case saintKittsAndNevis = "Saint Kitts and Nevis"
        case saintLucia = "Saint Lucia"
        case saintVincentAndTheGrenadines = "Saint Vincent and the Grenadines"
        case samoa = "Samoa"
        case sanMarino = "San Marino"
        case saoTomeAndPrincipe = "Sao Tome and Principe"
        case saudiArabia = "Saudi Arabia"
        case senegal = "Senegal"
        case serbia = "Serbia"
        case seychelles = "Seychelles"
        case sierraLeone = "Sierra Leone"
        case singapore = "Singapore"
        case slovakia = "Slovakia"
        case slovenia = "Slovenia"
        case solomonIslands = "Solomon Islands"
        case somalia = "Somalia"
        case southAfrica = "South Africa"
        case southSudan = "South Sudan"
        case spain = "Spain"
        case sriLanka = "Sri Lanka"
        case sudan = "Sudan"
        case summerOlympics2020 = "Summer Olympics 2020"
        case suriname = "Suriname"
        case sweden = "Sweden"
        case switzerland = "Switzerland"
        case syria = "Syria"
        case taiwan = "Taiwan*"
        case tajikistan = "Tajikistan"
        case tanzania = "Tanzania"
        case thailand = "Thailand"
        case timorLeste = "Timor-Leste"
        case togo = "Togo"
        case tonga = "Tonga"
        case trinidadAndTobago = "Trinidad and Tobago"
        case tunisia = "Tunisia"
        case turkey = "Turkey"
        case us = "US"
        case uganda = "Uganda"
        case ukraine = "Ukraine"
        case unitedArabEmirates = "United Arab Emirates"
        case unitedKingdom = "United Kingdom"
        case uruguay = "Uruguay"
        case uzbekistan = "Uzbekistan"
        case vanuatu = "Vanuatu"
        case venezuela = "Venezuela"
        case vietnam = "Vietnam"
        case westBankAndGaza = "West Bank and Gaza"
        case winterOlympics2022 = "Winter Olympics 2022"
        case yemen = "Yemen"
        case zambia = "Zambia"
        case zimbabwe = "Zimbabwe"
        case global = "Global"
    }
}

// MARK: - Global
struct Global: Decodable {
    let All: GlobalAll
}

// MARK: - GlobalAll
struct GlobalAll: Decodable {
    let population: Int?
    let confirmed: Int?
    let recovered:Int?
    let deaths: Int?
    let updated: String?
    let country: String
    let abbreviation: String?
    let capital_city: String?
    let continent: String?
    let life_expectancy: String?
    let location: String?
    
    var confirmedString: String {
        if let confirmed = confirmed {
            return "\(confirmed)"
        } else {
            return "N/A"
        }
    }
}
