//
//  Service.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit
import SwiftSoup

class Service {
    
    static let shard : Service = Service()
    
    let currentLang = Locale.current.languageCode
    
    //MARK: - Core Data
    
    let coreDataManager = CoreDateManager()
    var tasksArray = [CoreDataList]()
    
    func fetchData() {
        tasksArray = coreDataManager.fetchData() ?? [CoreDataList]()
    }
    
    func saveData(flightNumber: String, notes: String, date: Date){
        coreDataManager.saveData(flightNumber: flightNumber, tasks: notes, date: date)
    }
    
    func deleteData(index: Int) {
        coreDataManager.deleteData(index: index)
    }
    
    //MARK: - Arrays
    
    var dataArrayFlights = [Record]()
    var dataArrayTravelWarnings = [TravelWarningRecored]()
    var dataArrayCovid = [Covid]()
    var dataArrayCovidAll: [Global] = []
    var dataArrayEmbassies = [EmbassiesRecord]()
    var dataArrayForeignMissions = [ForeignMissionsRecord]()
    
    //MARK: - Setup View
    
    func setupViews(view: UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
    }
    
    
    //MARK: - Animation
    
    func animationViewCircle(view: UIView) {
        
        let oldValue = view.frame.width/2
        let newViewWidth: CGFloat = 60
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
        cornerAnimation.fromValue = oldValue
        cornerAnimation.toValue = newViewWidth/2
        
        view.layer.cornerRadius = newViewWidth/2
        view.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
        
        CATransaction.commit()
    }
    
    func animateView(view: UIView){
        let newButtonWidth: CGFloat = 60
        
        UIView.animate(withDuration: 2.0) {
            view.frame = CGRect(x: 0, y: 0, width: newButtonWidth, height: newButtonWidth)
            view.center = view.center
        }
    }
    
    func animateTableView(tableView: UITableView) {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func animateButton(button: UIButton){
        UIView.animate(withDuration: 0.6,
                       animations: {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.6) {
                button.transform = CGAffineTransform.identity
            }
        })
    }
    
    func animateCollectionView(cell: UICollectionViewCell){
        let trans = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = trans
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    //MARK: - Convert to Date
    
    func dateFormat(date: String) -> String {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
        let convertDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy "
        let formattedDateInString = dateFormatter.string(from: convertDate!)
        return formattedDateInString
    }
    
    func htmlToString(htmlString: String) -> String {
        do {
            let html: String = htmlString
            if html.contains("<a") {
            } else {
                return htmlString
            }
            let doc: Document = try SwiftSoup.parse(html)
            let text: String = try doc.body()!.text()
            return text
        } catch {
            print("error")
            return ""
        }
    }
}
