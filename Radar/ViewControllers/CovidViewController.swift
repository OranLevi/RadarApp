//
//  CovidViewController.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

class CovidViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var covidCollectionView: UICollectionView!
    
    var service = Service.shard
    var filteredData = [Global]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        covidCollectionView.dataSource = self
        covidCollectionView.delegate = self
        searchBar.delegate = self
        setupView()
        hideKeyboardOnTapOnView()
        Task {
            _ = await NetworkService().getCovidData()
            checkIfEmpty()
            spinner.stopAnimating()
            spinner.isHidden = true
            covidCollectionView.reloadData()
        }
    }
    
    var realArray: [Global] {
        if isSearching {
            return filteredData
        } else {
            return service.dataArrayCovidAll
        }
    }
    
    func setupView() {
        searchBarViews(searchBar: searchBar)
        spinner.startAnimating()
    }
    
    func checkIfEmpty(){
        if service.dataArrayCovidAll.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
            label.center = view.center
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = NSLocalizedString("NETWORK_ERROR", comment: "")
            
            self.view.addSubview(label)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? CovidDetailsViewController else { return }
        
        if let indexPath = covidCollectionView?.indexPathsForSelectedItems?.first {
            detailViewController.selectCountry = realArray[indexPath.row]
        }
    }
    
}

//MARK: - Collection View Data Source

extension CovidViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = covidCollectionView.dequeueReusableCell(withReuseIdentifier: "covidCell", for: indexPath) as! CovidCollectionViewCell
        
        service.setupViews(view: cell)
        checkIfEmpty()
        let item = realArray [indexPath.row]
        
        cell.covidCountryLabel.text = item.All.country
        
        cell.covidPopulationLabel.text = item.All.population.toString()
        cell.covidConfirmedLabel.text = item.All.confirmed.toString()
        cell.covidDeathsLabel.text = item.All.deaths.toString()
        cell.covidImageView.image = UIImage(named: "\(item.All.abbreviation ?? "nil")")
        
        return cell
    }
}

//MARK: - Collection View Delegate

extension CovidViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        service.animateCollectionView(cell: cell)
    }
}

//MARK: - SerachBar Delegate

extension CovidViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            covidCollectionView.reloadData()
        } else {
            isSearching = true
            filteredData = service.dataArrayCovidAll.filter({$0.All.country.lowercased().contains(searchText.lowercased()) })
            covidCollectionView.reloadData()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
