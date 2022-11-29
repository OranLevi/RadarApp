//
//  CovidDetailsViewController.swift
//  Radar
//
//  Created by Oran on 05/08/2022.
//

import UIKit

class CovidDetailsViewController: UIViewController {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var covidDetailsTableView: UITableView!
    
    var selectCountry: Global?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        covidDetailsTableView.dataSource = self
        setupImage()
        setupLabels()
        service.animateTableView(tableView: covidDetailsTableView)
    }
    
    func setupImage(){
        flagImageView.image = UIImage(named: (selectCountry?.All.abbreviation)!)
    }
    
    func setupLabels(){
        country.text = selectCountry?.All.country
    }
}

//MARK: - Table View Data Source

extension CovidDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = covidDetailsTableView.dequeueReusableCell(withIdentifier: "covidDetailsCell", for: indexPath) as! CovidDetailsTableViewCell
        
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.keyLabel.text = NSLocalizedString("POPULATION", comment: "")
            cell.valueLabel.text = selectCountry?.All.population.toString()
        } else if indexPath.row == 1 {
            cell.keyLabel.text = NSLocalizedString("CONFIRMED", comment: "")
            cell.valueLabel.text = selectCountry?.All.confirmedString ?? NSLocalizedString("N/A", comment: "")
        }
        else if indexPath.row == 2 {
            cell.keyLabel.text = NSLocalizedString("LIFE_EXPECTANCY", comment: "")
            cell.valueLabel.text = selectCountry?.All.life_expectancy ?? NSLocalizedString("N/A", comment: "")
        }
        else if indexPath.row == 3 {
            cell.keyLabel.text = NSLocalizedString("CONTINENT", comment: "")
            cell.valueLabel.text = selectCountry?.All.continent ?? NSLocalizedString("N/A", comment: "")
        }
        else if indexPath.row == 4 {
            cell.keyLabel.text = NSLocalizedString("LOCATION", comment: "")
            cell.valueLabel.text = selectCountry?.All.location ?? NSLocalizedString("N/A", comment: "")
        }
        else if indexPath.row == 5 {
            cell.keyLabel.text = NSLocalizedString("CAPITAL_CITY", comment: "")
            cell.valueLabel.text = selectCountry?.All.capital_city ?? NSLocalizedString("N/A", comment: "")
        }
        else if indexPath.row == 6 {
            cell.keyLabel.text = NSLocalizedString("LAST_UPDATED", comment: "")
            cell.valueLabel.text = selectCountry?.All.updated ?? NSLocalizedString("N/A", comment: "")
        }
        return cell
    }
}
