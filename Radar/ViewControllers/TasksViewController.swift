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
    @IBOutlet weak var editButton: UIBarButtonItem!
    var deleteButtonTap = false

    let service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfEmpty()
        updateTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        taskTableView.isEditing = false
        deleteButtonTap = false
    }
    
    func updateTableView(){
        service.fetchData()
        checkIfEmpty()
        taskTableView.reloadData()
    }
    
    func checkIfEmpty() {
        
        // Empty Label
        if service.tasksArray.count != 0 {
            emptyLabel.isHidden = true
        } else {
            emptyLabel.isHidden = false
        }
        
        // Edit Button
        if service.tasksArray.count == 0 {
            if #available(iOS 16.0, *) { editButton.isHidden = true } else {
                editButton.isEnabled = false
                editButton.tintColor = UIColor.clear
            }
        } else {
            if #available(iOS 16.0, *) { editButton.isHidden = false } else {
                editButton.isEnabled = true
                editButton.tintColor = UIColor.systemBlue
            }
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
     
        if deleteButtonTap {
            taskTableView.isEditing = false
            deleteButtonTap = false
        } else {
            taskTableView.isEditing = true
            deleteButtonTap = true
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let headerCell = tableView.dequeueReusableCell(withIdentifier: "CustomHeaderTask") as! CustomHeaderTask
        
        headerCell.flightDate.text = NSLocalizedString("TASK_FLIGHT_DATE", comment: "")
        headerCell.flightNumberTask.text = NSLocalizedString("TASK_NUMBER_FALIGH_TASK", comment: "")
            return headerCell
        }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if service.tasksArray.isEmpty { return 0 } else { return 40 }
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
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//
//        let itemToMove = service.tasksArray[sourceIndexPath.row]
//        service.tasksArray.remove(at: sourceIndexPath.row)
//        service.tasksArray.insert(itemToMove, at: destinationIndexPath.row)
//
//        context.delete(service.tasksArray[sourceIndexPath.row])
//        context.insert(service.tasksArray[destinationIndexPath.row])
//        do {
//                try context.save()
//
//            } catch let error as NSError {
//                print("Could not save item to Core Data: \(error)")
//            }
    }
}
