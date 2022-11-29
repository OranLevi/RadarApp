//
//  TasksViewController.swift
//  Radar
//
//  Created by Oran on 28/07/2022.
//

import UIKit

class TasksViewController: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    let service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfEmpty()
        updateTableView()
    }
    
    func updateTableView(){
        service.fetchData()
        checkIfEmpty()
        taskTableView.reloadData()
    }
    
    func checkIfEmpty() {
        if service.tasksArray.count != 0 {
            emptyLabel.isHidden = true
        } else {
            emptyLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? TaskDetailsViewController,
              let index = taskTableView.indexPathForSelectedRow?.row
        else {
            return
        }
        detailViewController.selectTask = service.tasksArray[index]
    }
    
}

//MARK: - Table View Data Source

extension TasksViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! TaskTableViewCell
        
        let item = service.tasksArray[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDateInString = formatter.string(from: item.date!)
        
        cell.flightNumber.text = item.flightNumber
        cell.dateLabel.text = formattedDateInString
        cell.tasks.text = item.tasks
        
        return cell
    }
}

//MARK: - Table View Delegate

extension TasksViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            service.deleteData(index: indexPath.row)
            updateTableView()
        }
    }
}
