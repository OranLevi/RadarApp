//
//  EmbassiesViewController.swift
//  Radar
//
//  Created by Oran on 01/08/2022.
//

import UIKit

class EmbassiesViewController: UIViewController {
    
    @IBOutlet weak var embassiesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var service = Service.shard
    var filteredData = [EmbassiesRecord]()
    var searchTimer: Timer?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embassiesTableView.dataSource = self
        embassiesTableView.delegate = self
        searchBar.delegate = self
        setupView()
        hideKeyboardOnTapOnView()
        Task {
            _ = await NetworkService().getEmbassiesData(NetworkService().embassiesLang)
            checkIfEmpty()
            service.animateTableView(tableView: embassiesTableView)
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    var realArray: [EmbassiesRecord] {
        if isSearching {
            return filteredData
        } else {
            return service.dataArrayEmbassies
        }
    }
    
    func checkIfEmpty(){
        if service.dataArrayEmbassies.isEmpty {
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
        spinner.startAnimating()
        searchBarViews(searchBar: searchBar)
    }
}

//MARK: - Table View Data Source

extension EmbassiesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = embassiesTableView.dequeueReusableCell(withIdentifier: "embassiesCell", for: indexPath) as! EmbassiesTableViewCell
        
        let item = realArray[indexPath.row]
        
        cell.country.text = item.country(lang: service.currentLang!)
        cell.status.text = item.status(lang: service.currentLang!)
        
        return cell
    }
}

//MARK: - Table View Delegate

extension EmbassiesViewController: UITableViewDelegate {
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

//MARK: - Serach Deleagte

extension EmbassiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            embassiesTableView.reloadData()
        } else {
            isSearching = true
            self.searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                Task {
                    self.filteredData = self.service.dataArrayEmbassies.filter({$0.country(lang: self.service.currentLang!).lowercased().contains(searchText.lowercased()) })
                    self.embassiesTableView.reloadData()
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
