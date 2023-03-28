//
//  ForeignMissionsViewController.swift
//  Radar
//
//  Created by Oran on 05/08/2022.
//

import UIKit

class ForeignMissionsViewController: UIViewController {
    
    @IBOutlet weak var ForeignMissionsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var service = Service.shard
    var filteredData = [ForeignMissionsRecord]()
    var searchTimer: Timer?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ForeignMissionsTableView.dataSource = self
        ForeignMissionsTableView.delegate = self
        searchBar.delegate = self
        setupView()
        hideKeyboardOnTapOnView()
        Task {
            _ = await NetworkService().getForeignMissionsData(NetworkService().foreignMissionsLang)
            checkIfEmpty()
            //            ForeignMissionsTableView.reloadData()
            service.animateTableView(tableView: ForeignMissionsTableView)
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    var realArray: [ForeignMissionsRecord] {
        if isSearching {
            return filteredData
        } else {
            return service.dataArrayForeignMissions
        }
    }
    
    func checkIfEmpty(){
        if service.dataArrayForeignMissions.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
            label.center = view.center
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = NSLocalizedString("NETWORK_ERROR", comment: "")

            
            self.view.addSubview(label)
        }
    }
    
    func setupView() {
        searchBarViews(searchBar: searchBar)
        spinner.center = self.view.center
        spinner.startAnimating()
    }
}

//MARK: - Table View Data Source

extension ForeignMissionsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ForeignMissionsTableView.dequeueReusableCell(withIdentifier: "foreignMissionsCell", for: indexPath) as! ForeignMissionsTableViewCell
        
        let item = realArray[indexPath.row]
        
        cell.country.text = item.country(lang: service.currentLang!)
        cell.status.text = item.status(lang: service.currentLang!)
        return cell
    }
}

//MARK: - Table View Delegate

extension ForeignMissionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = realArray[indexPath.row]
        let str = item.address(lang: service.currentLang!)
        let path = "http://maps.apple.com/?q=" + str
    
        if let pathWithPercent = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: pathWithPercent) {
            UIApplication.shared.open(url)
        }
    }
}

//MARK: - Serach Delegate

extension ForeignMissionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            ForeignMissionsTableView.reloadData()
        } else {
            isSearching = true
            self.searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                Task {
                    self.filteredData = self.service.dataArrayForeignMissions.filter({$0.country(lang: self.service.currentLang!).lowercased().contains(searchText.lowercased()) })
                    self.ForeignMissionsTableView.reloadData()
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
