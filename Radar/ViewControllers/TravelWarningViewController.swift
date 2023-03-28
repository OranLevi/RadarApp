//
//  TravelWarningViewController.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

class TravelWarningViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var travelWarningCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var service = Service.shard
    var filteredData = [TravelWarningRecored]()
    var isSearching = false
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupView()
        hideKeyboardOnTapOnView()
        Task{
            if service.dataArrayTravelWarnings.isEmpty {
                _ = await NetworkService().getTravelWarningsData(.travelWarnings)
            }
            checkIfEmpty()
            travelWarningCollectionView.reloadData()
            spinner.stopAnimating()
            spinner.isHidden = true
        }
        
    }
    
    var realArray: [TravelWarningRecored] {
        if isSearching {
            return filteredData
        } else {
            return service.dataArrayTravelWarnings
        }
    }
    
    func checkIfEmpty(){
        if service.dataArrayTravelWarnings.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
            label.center = view.center
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = NSLocalizedString("NETWORK_ERROR", comment: "")

            
            self.view.addSubview(label)
        }
    }
    
    func setupView() {
        spinner.center = self.view.center
        searchBarViews(searchBar: searchBar)
        spinner.startAnimating()
    }
    
}

//MARK: - Collection View Data Source

extension TravelWarningViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = travelWarningCollectionView.dequeueReusableCell(withReuseIdentifier: "travelWarningCell", for: indexPath) as! TravelWarningCollectionViewCell
        
        service.setupViews(view: cell)
        
        let item = realArray[indexPath.row]
        
        Task{
            await cell.imageView.getImage(path:item.logo)
        }
        cell.continentLabel.text = item.continent
        cell.countryLabel.text = item.country
        cell.officeLabel.text = item.office
        cell.recommendationsLabel.text = service.htmlToString(htmlString: item.recommendations)
        
        return cell
    }
}

//MARK: - Collection View Delegate

extension TravelWarningViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = realArray[indexPath.row]
        
        let fixedMessage = "\(NSLocalizedString("COUNTRY", comment: "")) \n\(item.country)\n\n \(NSLocalizedString("RECOMMENDATIONS", comment: "")) \n \(service.htmlToString(htmlString: item.recommendations)) \n\n \(NSLocalizedString("OFFICE_REPORTS", comment: ""))\n \(item.office ?? NSLocalizedString("N/A", comment: ""))"
        
        if item.recommendations == "אין המלצות " {
            self.showAlert(title: NSLocalizedString("ALERT", comment: ""), message: fixedMessage, alertType: .ok)
        } else if item.recommendations == "אין אזהרות" {
            self.showAlert(title: NSLocalizedString("ALERT", comment: ""), message: fixedMessage, alertType: .ok)
        } else {
            self.showAlert(title: NSLocalizedString("ALERT", comment: ""), message: fixedMessage, alertType: .warning)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        service.animateCollectionView(cell: cell)
    }
}

//MARK: - Collection View Delegate Flow Layout

extension TravelWarningViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 67 , height: 124);
    }
}

//MARK: - Serach Delegate

extension TravelWarningViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            travelWarningCollectionView.reloadData()
        } else {
            isSearching = true
            self.searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                Task {
                    self.filteredData = self.service.dataArrayTravelWarnings.filter({$0.country.lowercased().contains(searchText.lowercased()) || $0.continent.lowercased().contains(searchText.lowercased()) || $0.office!.lowercased().contains(searchText.lowercased())
                    })
                    self.travelWarningCollectionView.reloadData()
                }
            }
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
