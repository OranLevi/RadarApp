//
//  AddTasksViewController.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

class AddTasksViewController: UIViewController {
    
    @IBOutlet weak var flightDetailsView: UIView!
    @IBOutlet weak var flightNumberTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let service = Service()
    var userClickCheckBox = false
    var userClickCheckData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapOnView()
        flightNumberTextField.autocapitalizationType = .allCharacters
    }
    
    @IBAction func dataPicker(_ sender: Any) {
        userClickCheckBox = true
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if notesTextView.text.isEmpty {
            showAlert(title: NSLocalizedString("ERROR", comment: ""), message: NSLocalizedString("PLEASE_FILL_YOUR_TASK", comment: ""))
        } else if notesTextView.text.isEmpty && userClickCheckBox == true {
            showAlert(title: NSLocalizedString("ERROR", comment: ""), message: NSLocalizedString("PLEASE_FILL_IN_EMPTY_FIELDS", comment: ""))
        } else if userClickCheckBox == false {
            showAlert(title: NSLocalizedString("ERROR", comment: ""), message: NSLocalizedString("CHOOSE_DATE", comment: ""))
        }else if flightNumberTextField.text == "" {
            showAlert(title: NSLocalizedString("ERROR", comment: ""), message: NSLocalizedString("ENTER_FLIGHT_NUMBER", comment: ""))
        } else {
            self.service.saveData(flightNumber: flightNumberTextField.text!, notes: notesTextView.text!, date: datePicker.date)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}


