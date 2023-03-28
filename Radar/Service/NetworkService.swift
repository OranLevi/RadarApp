//
//  NetworkService.swift
//  Radar
//
//  Created by Oran on 01/08/2022.
//

import UIKit

class NetworkService {
    
    var service = Service.shard
    
    var travelWarningsTotal:Int = 0
    var embassiesIsraelTotal:Int = 0
    var foreignMissionsTotal:Int = 0
    var flightsTimeTableTotal:Int = 0
    
    var covidDataUrl = "https://covid-api.mmediagroup.fr/v1/cases"
    
    enum TypeUrl: String {
        case flights = "e83f763b-b7d7-479e-b172-ae981ddc6de5"
        case travelWarnings = "2a01d234-b2b0-4d46-baa0-cec05c401e7d"
        case embassiesIsraelEn = "6fc859cb-8a6f-458b-bd5a-9bd0cfbfce11"
        case embassiesIsraelHe = "4d1ce6f0-08d9-4294-a7ae-aae1b29bb769"
        case foreignMissionsInIsraelEn = "dffd4e30-2330-4c1c-893c-e2df910fe1d4"
        case foreignMissionsInIsraelHe = "95ce3d91-34fb-42d2-bcb7-fefdf54cee42"
    }
    
    var embassiesLang : TypeUrl {
        if Service().currentLang == "he"{
            return .embassiesIsraelHe
        } else {
            return .embassiesIsraelEn
        }
    }
    
    var foreignMissionsLang : TypeUrl {
        if Service().currentLang == "he"{
            return .foreignMissionsInIsraelHe
        } else {
            return .foreignMissionsInIsraelEn
        }
    }
    
    //MARK: - components URLS
    
    func serviceUrl(for suffix: TypeUrl, total: Int) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "data.gov.il"
        components.path = "/api/3/action/datastore_search"
        components.queryItems = [
            URLQueryItem(name: "resource_id", value: suffix.rawValue),
            URLQueryItem(name: "limit", value: String(total)),
        ]
        let url = components.url!
        return url
    }
    
    func getTotalUrl(for suffix: TypeUrl) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "data.gov.il"
        components.path = "/api/3/action/datastore_search"
        components.queryItems = [
            URLQueryItem(name: "resource_id", value: suffix.rawValue),
        ]
        let url = components.url!
        return url
    }
    
    //MARK: - Get Data
    
    func getTotal(_ typeUrl: TypeUrl) async {
        let url = getTotalUrl(for: typeUrl)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if typeUrl == .travelWarnings {
                let warnings = try JSONDecoder().decode(TravelWarnings.self, from: data)
                travelWarningsTotal = warnings.result.total
            } else if typeUrl == .embassiesIsraelEn || typeUrl == .embassiesIsraelHe {
                let embassies = try JSONDecoder().decode(Embassies.self, from: data)
                embassiesIsraelTotal = embassies.result.total
            } else if typeUrl == .foreignMissionsInIsraelEn || typeUrl == .foreignMissionsInIsraelHe{
                let ForeignMissions = try JSONDecoder().decode(ForeignMissions.self, from: data)
                foreignMissionsTotal = ForeignMissions.result.total
            } else if typeUrl == .flights || typeUrl == .flights{
                let flights = try JSONDecoder().decode(Flights.self, from: data)
                flightsTimeTableTotal = flights.result.total
            }
     
        } catch {
            print("ERROR: getTotal", error)
            return
        }
    }
    
    func getFlightsData(_ typeUrl: TypeUrl) async -> Flights? {
        await getTotal(.flights)
        let url = serviceUrl(for: typeUrl, total: flightsTimeTableTotal)
       
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let flight = try JSONDecoder().decode(Flights.self, from: data)
            self.service.dataArrayFlights.append(contentsOf: flight.result.records)
            return flight
        } catch {
            print("ERROR: getFlightsData", error)
            return nil
        }
    }
    
    func getTravelWarningsData(_ typeUrl: TypeUrl) async -> TravelWarnings? {
        await getTotal(.travelWarnings)
        let url = serviceUrl(for: typeUrl, total: travelWarningsTotal)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let warnings = try JSONDecoder().decode(TravelWarnings.self, from: data)
                self.service.dataArrayTravelWarnings.append(contentsOf: warnings.result.records)
            return warnings
        } catch {
            print("ERROR: getTravelWarnings", error)
            return nil
        }
    }
    
    func getEmbassiesData(_ typeUrl: TypeUrl) async -> Embassies? {
        await getTotal(embassiesLang)
        let url = serviceUrl(for: typeUrl, total: embassiesIsraelTotal)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let embassies = try JSONDecoder().decode(Embassies.self, from: data)
                self.service.dataArrayEmbassies.append(contentsOf: embassies.result.records)
            return embassies
        } catch {
            print("ERROR: getEmbassies", error)
            return nil
        }
    }
    
    func getForeignMissionsData(_ typeUrl: TypeUrl) async -> ForeignMissions? {
        await getTotal(foreignMissionsLang)
        let url = serviceUrl(for: typeUrl, total: foreignMissionsTotal)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let foreignMissions = try JSONDecoder().decode(ForeignMissions.self, from: data)
                self.service.dataArrayForeignMissions.append(contentsOf: foreignMissions.result.records)
            return foreignMissions
        } catch {
            print("ERROR: getForeignMissions", error)
            return nil
        }
    }
    
    func getCovidData() async  -> Covid? {
        let covidData = covidDataUrl
        guard let dataUrl = URL(string: covidData) else {
            return nil
        }
       
        do {
            let (data, _ ) = try await URLSession.shared.data(from: dataUrl)
            let covid = try JSONDecoder().decode(Covid.self, from: data)
            service.dataArrayCovid.append(covid)
            return covid
        } catch (let error) {
            print("ERROR: getCovidData", error)
            return nil
        }
    }
}
