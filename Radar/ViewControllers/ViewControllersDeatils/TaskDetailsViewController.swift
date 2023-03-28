//
//  TaskDetailsViewController.swift
//  Radar
//
//  Created by Oran on 05/08/2022.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    var selectTask: CoreDataList?
    
    @IBOutlet weak var flightNumberView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var task: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLabels()
    }
    
    func setupView() {
        service.setupViews(view: flightNumberView)
        service.setupViews(view: dateView)
    }
    
    func setupLabels(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        flightNumber.text = selectTask?.flightNumber
        dateLabel.text = dateFormatter.string(from: (selectTask?.date)!)
        task.text = selectTask?.tasks
    }
}
