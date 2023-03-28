//
//  FlightTimeTableViewController.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

class FlightTimeTableViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var flightTimeTableCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var changeLang: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var service = Service.shard
    var filteredDataSearch = [Record]()
    var filteredDataSegmented = [Record]()
    var isSearching = false
    var isSegmented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapOnView()
        flightTimeTableCollectionView.delegate = self
        flightTimeTableCollectionView.dataSource = self
        searchBar.delegate = self
        setupView()

        Task {
            _ = await NetworkService().getFlightsData(.flights)
            checkIfEmpty()
            spinner.stopAnimating()
            spinner.center = self.view.center
            spinner.isHidden = true
            flightTimeTableCollectionView.reloadData()
        }
    }

    var realArray: [Record] {
        if isSegmented {
            return filteredDataSegmented
        }else if isSearching {
            return filteredDataSearch
        } else {
            return service.dataArrayFlights
        }
    }
    
    func setupView() {
        searchBarViews(searchBar: searchBar)
        searchBar.autocapitalizationType = .allCharacters
        spinner.center = self.view.center
        spinner.startAnimating()
        changeLang.title = NSLocalizedString("BUTTON_LANG", comment: "")
    }
    
    func checkIfEmpty(){
        if service.dataArrayFlights.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
            label.center = view.center
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = NSLocalizedString("NETWORK_ERROR", comment: "")

            
            self.view.addSubview(label)
        }
    }
    
    @IBAction func flightSegmented(_ sender: Any) {
        isSegmented = true
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            searchBar.text = ""
            isSegmented = false
            isSearching = false
            filteredDataSegmented = service.dataArrayFlights
            flightTimeTableCollectionView.setContentOffset(CGPoint.zero, animated: true)
        case 1:
            searchBar.text = ""
            filteredDataSegmented = service.dataArrayFlights.filter({$0.statusEn.lowercased().contains("Landed".lowercased()) })
            flightTimeTableCollectionView.setContentOffset(CGPoint.zero, animated: true)
        case 2:
            searchBar.text = ""
            filteredDataSegmented = service.dataArrayFlights.filter({$0.statusEn.lowercased().contains("Departed".lowercased()) })
            flightTimeTableCollectionView.setContentOffset(CGPoint.zero, animated: true)

        case 3:
            searchBar.text = ""
            filteredDataSegmented = service.dataArrayFlights.filter({$0.statusEn.lowercased().contains("Canceled".lowercased()) })
            flightTimeTableCollectionView.setContentOffset(CGPoint.zero, animated: true)

        default:
            break
            
        }
        flightTimeTableCollectionView.reloadData()
    }
    
    @IBAction func changeLang(_ sender: Any) {
        changeLang(title: NSLocalizedString("TITLE_CHANGE_LANG", comment: ""), message: NSLocalizedString("MES_CHANGE_LANG", comment: ""), titleOk: NSLocalizedString("BUTTON_OK_CHANGE_LANG", comment: ""), titleCancel: NSLocalizedString("BUTTON_CANCEL_CHANGE_LANG", comment: ""))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? FlightTimeTableDetailsViewController else { return }
        
        if let indexPath = flightTimeTableCollectionView?.indexPathsForSelectedItems?.first {
            detailViewController.selectFlight = realArray[indexPath.row]
        }
    }
}

//MARK: - Collection View Data Source

extension FlightTimeTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = flightTimeTableCollectionView.dequeueReusableCell(withReuseIdentifier: "flightTimeCell", for: indexPath) as! FlightTimeTableCollectionViewCell
        
        service.setupViews(view: cell)
        
        let item = realArray[indexPath.row]
        
        if item.kind == "D" {
            cell.destinationLabel.text = "\(NSLocalizedString("DESTINATION_ISRAEL_TO", comment: "")) \(item.city(lang: service.currentLang!))"
            
            cell.imageView.image = UIImage(systemName: "airplane.departure")
            cell.timeLabel.text = "\(NSLocalizedString("DESTINATION_TIME", comment: ""))\(service.dateFormat(date: item.currentTime))"
            cell.statesLabel.backgroundColor = UIColor.systemBlue
            
        } else {
            
            cell.destinationLabel.text = "\(item.city(lang: service.currentLang!)) \(NSLocalizedString("DESTINATION_TO_ISRAEL", comment: ""))"
            cell.imageView.image = UIImage(systemName: "airplane.arrival")
            cell.timeLabel.text = "\(NSLocalizedString("LANDING_TIME", comment: ""))\(service.dateFormat(date: item.currentTime))"
            cell.statesLabel.backgroundColor = UIColor.systemOrange
        }
        
        if item.statusEn == "CANCELED"{
            cell.statesLabel.backgroundColor = UIColor.systemRed
        }
        
        cell.flightNumberLabel.text = "\(item.flightLetter) \(item.flightNumber)"
        cell.airlinesLabel.text = item.airlinesName
        cell.statesLabel.text = item.status(lang: service.currentLang!)
        cell.statesLabel.layer.cornerRadius = 5
        cell.statesLabel.layer.masksToBounds = true
        
        return cell
    }
    
}

//MARK: - Collection View Delegate

extension FlightTimeTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        service.animateCollectionView(cell: cell)
    }
}

//MARK: - Collection View Delegate Flow Layout

extension FlightTimeTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 67 , height: 124);
    }
}

//MARK: - SerachBar

extension FlightTimeTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            flightTimeTableCollectionView.reloadData()
        } else if searchBar.text != "" && isSegmented == false {
            isSearching = true
            filteredDataSearch = service.dataArrayFlights.filter({
                $0.flightLetterNumber.lowercased().contains(searchText.lowercased()) || $0.flightLetterNumberSpace.lowercased().contains(searchText.lowercased()) || $0.airlinesName.lowercased().contains(searchText.lowercased()) || $0.city(lang: "all").lowercased().contains(searchText.lowercased())
            })
            flightTimeTableCollectionView.reloadData()
            flightTimeTableCollectionView.setContentOffset(CGPoint.zero, animated: true)
        } else if searchBar.text != "" && isSegmented == true {
            segmentedControl.selectedSegmentIndex = 0;
            isSegmented = false
            isSearching = true
            filteredDataSearch = service.dataArrayFlights
        }
        flightTimeTableCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
