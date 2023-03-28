//
//  Extension.swift
//  Radar
//
//  Created by Oran on 30/07/2022.
//

import UIKit
import SwiftSoup

//MARK: - UIViewController

extension UIViewController {
    func hideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

public extension UIViewController {
    
    enum AlertType{
        case ok
        case cancel
        case warning
    }
    
    func showAlert(title: String, message: String, alertType: AlertType ) {
        guard let showAlert = UIStoryboard(name: "Alert", bundle: nil)
            .instantiateViewController(withIdentifier: "Alert") as? AlertViewController else {
            return
        }
        
        showAlert.titleAlert = title
        showAlert.messageAlert = message
        if alertType == .ok {
            showAlert.imageViewAlert = "checkmark.circle"
            showAlert.colorImage = .systemGreen
            showAlert.colorButtonAlert = UIColor.blue

        } else if alertType == .cancel {
            showAlert.imageViewAlert = "x.circle"
            showAlert.colorImage = .systemRed
            showAlert.colorButtonAlert = UIColor.blue
        } else if alertType == .warning {
            showAlert.imageViewAlert = "exclamationmark.triangle"
            showAlert.colorImage = .systemYellow
            showAlert.colorButtonAlert = UIColor.blue
        }
        
        self.addChild(showAlert)
        self.view.addSubview(showAlert.view)
        showAlert.didMove(toParent: self)
    }
    
    func searchBarViews(searchBar : UISearchBar) {
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchBar.backgroundColor = self.navigationController?.navigationBar.barTintColor
    }
    
    // MARK: - alert
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
        }
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func changeLang(title: String, message: String, titleOk: String, titleCancel: String){
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: titleOk, style: .default, handler: { (action) -> Void in
            let currentLang = Locale.current.languageCode
            print("current Lange: \(String(describing: currentLang))")
            let newLanguages = currentLang == "en" ? "he" : "en"
            UserDefaults.standard.setValue([newLanguages], forKey: "AppleLanguages")
            exit(0)
        })
        
        let cancel = UIAlertAction(title: titleCancel, style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

//MARK: - UIImageView

extension UIImageView {
    
    func getImage(path: String) async {
        do {
            let html = path
            let document = try SwiftSoup.parse(html)
            let imageElement = try document.select("img").first()
            if let src = try imageElement?.attr("src") {
                guard let url = URL(string: src) else {
                    return
                }
                let request = URLRequest(url: url)
                
                let (data, _) = try await URLSession.shared.data(for: request)
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
        } catch {
            print("error")
        }
    }
}

//MARK: - String

extension String {
    
    func localized(tableName: String = "Localizable") -> String {
        if let languageCode = Locale.current.languageCode, let preferredLanguagesFirst = Locale.preferredLanguages.first?.prefix(2)  {
            if languageCode != preferredLanguagesFirst {
                if let path = Bundle.main.path(forResource: "en", ofType: "lproj") {
                    let bundle = Bundle.init(path: path)
                    return NSLocalizedString(self, tableName: tableName, bundle: bundle!, value: self, comment: "")
                }
            }
        }
        return NSLocalizedString(self, tableName: tableName, value: self, comment: "")
    }
}

//MARK: - Optional

extension Optional where Wrapped == Int {
    
    func toString(replacementString: String = NSLocalizedString("N/A", comment: "")) -> String {
        if let int = self {
            return String(int)
        }
        return replacementString
    }
}
