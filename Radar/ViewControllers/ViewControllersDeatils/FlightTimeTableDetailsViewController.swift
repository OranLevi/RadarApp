//
//  FlightDetailsViewController.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

class FlightTimeTableDetailsViewController: UIViewController {
    
    @IBOutlet weak var flightDetailsTableView: UITableView!
    @IBOutlet weak var flightView: UIView!
    @IBOutlet weak var warningTravelWarning: UIView!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var airlinesName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var travelWarningLabel: UILabel!
    
    var selectFlight: Record?
    var service = Service.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLabels()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        tabBarController?.selectedIndex = 1
    }
    
    func setupView() {
        service.setupViews(view: flightView)
        service.setupViews(view: warningTravelWarning)
        service.animateTableView(tableView: flightDetailsTableView)
        service.animateView(view: warningTravelWarning)
        warningTravelWarning.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        warningTravelWarning.addGestureRecognizer(tap)
    }
    
    func setupLabels(){
        travelWarningLabel.text = NSLocalizedString("TRAVEL_WARNING_MES", comment: "")
        
        if selectFlight!.kind == "D" {
            destination.text = "\(NSLocalizedString("DESTINATION_ISRAEL_TO", comment: "")) \(selectFlight!.city(lang: service.currentLang!))"
            imageView.image = UIImage(systemName: "airplane.departure")
        } else {
            destination.text = "\(selectFlight!.city(lang: service.currentLang!)) \(NSLocalizedString("DESTINATION_TO_ISRAEL", comment: ""))"
            imageView.image = UIImage(systemName: "airplane.arrival")
        }
        airlinesName.text = "\(selectFlight?.flightLetter ?? "") \(selectFlight?.flightNumber ?? "")"
        
        Task{
            if service.dataArrayTravelWarnings.isEmpty {
            _ = await NetworkService().getTravelWarningsData(.travelWarnings)
            }
            if service.dataArrayTravelWarnings.contains(where: { $0.country  == selectFlight?.countryHe}) {
                warningTravelWarning.isHidden = false
            }
            if service.dataArrayTravelWarnings.contains(where: { $0.country  == selectFlight?.countryHe}) {
                warningTravelWarning.isHidden = false
            }
        }
    }
}

//MARK: - Table View Data Source

extension FlightTimeTableDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = flightDetailsTableView.dequeueReusableCell(withIdentifier: "flightDetailsCell", for: indexPath) as! FlightTimeTableDetailsTableViewCell
        
        if indexPath.row == 0 {
            cell.keyLabel.text = NSLocalizedString("AIRLINES_NAME", comment: "")
            cell.valueLabel.text = selectFlight?.airlinesName
        } else if indexPath.row == 1 {
            cell.keyLabel.text = NSLocalizedString("SCHEDULED_TIME", comment: "")
            cell.valueLabel.text = service.dateFormat(date: selectFlight!.scheduledTime)
        } else if indexPath.row == 2 {
            cell.keyLabel.text = NSLocalizedString("CURRENT_TIME", comment: "")
            cell.valueLabel.text = service.dateFormat(date: selectFlight!.currentTime)
        }
        else if indexPath.row == 3 {
            cell.keyLabel.text = NSLocalizedString("TERMINAL", comment: "")
            cell.valueLabel.text = selectFlight?.terminal
        }
        else if indexPath.row == 4 {
            cell.keyLabel.text = NSLocalizedString("DESTINATION_COUNTRY", comment: "")
            if service.currentLang == "en"{
                cell.valueLabel.text = selectFlight?.countryEn
            } else if service.currentLang == "he"{
                cell.valueLabel.text = selectFlight?.countryHe
            }
        }
        else if indexPath.row == 5 {
            cell.keyLabel.text = NSLocalizedString("DESTINATION_CITY", comment: "")
            if service.currentLang == "en"{
                cell.valueLabel.text = selectFlight?.cityEn
            } else if service.currentLang == "he"{
                cell.valueLabel.text = selectFlight?.cityHe
            }
        }
        else if indexPath.row == 6 {
            cell.keyLabel.text = NSLocalizedString("AIRPORT_CODE_IATA_CODE", comment: "")
            cell.valueLabel.text = selectFlight?.airportCode
        }
        else if indexPath.row == 7 {
            cell.keyLabel.text = NSLocalizedString("COUNTER_AREA", comment: "")
            cell.valueLabel.text = selectFlight?.counterArea ?? NSLocalizedString("N/A", comment: "")
            if selectFlight?.counterArea == "" {
                cell.valueLabel.text = NSLocalizedString("N/A", comment: "")
            }
        }
        else if indexPath.row == 8 {
            cell.keyLabel.text = NSLocalizedString("STATUS", comment: "")
            if service.currentLang == "en"{
                cell.valueLabel.text = selectFlight?.statusEn
            } else if service.currentLang == "he"{
                cell.valueLabel.text = selectFlight?.statusHe
            }
            if selectFlight?.statusEn == "DEPARTED" {
                cell.valueLabel.textColor = UIColor.systemBlue
                
            } else if selectFlight?.statusEn == "LANDED" {
                cell.valueLabel.textColor = UIColor.systemOrange
                
            }else if selectFlight?.statusEn == "CANCELED" {
                cell.valueLabel.textColor = UIColor.systemRed
            }
            cell.valueLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        }
        
        return cell
    }
}
