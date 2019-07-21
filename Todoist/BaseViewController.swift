//
//  ViewController.swift
//  Todoist
//
//  Created by Jerome Rodriguez on 29/6/19.
//  Copyright © 2019 Jerome Rodriguez. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddTaskViewControllerDelegateProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    public struct TodoCellContent {
        var todoCategory: String
        var todoTitle: String
        var todoDeadline: String
    }
    
    var todoList = [TodoCellContent]()
    var tableIndex = 0
    var segueViaAdd = false
    var todoCellContent: TodoCellContent = TodoCellContent(todoCategory: "", todoTitle: "", todoDeadline: "")
    
    func sendDataToTableView(titleToSend: String, categoryToSend: String, dateToSend: String, segueViaAdd: Bool, tableIndex: Int) {
        todoCellContent = TodoCellContent(todoCategory: categoryToSend, todoTitle: titleToSend, todoDeadline: dateToSend)
        if segueViaAdd == true {
            todoList.append(todoCellContent)
        } else {
            todoList[tableIndex] = todoCellContent
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddTodoSegue") {
            let addTaskVC = segue.destination as! AddTaskViewController
            addTaskVC.delegate = self
        } else {
            let addTaskVC = segue.destination as! AddTaskViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                addTaskVC.taskLabel = todoList[indexPath.row].todoTitle
                addTaskVC.taskCategory = todoList[indexPath.row].todoCategory
                addTaskVC.taskTime = todoList[indexPath.row].todoDeadline
                addTaskVC.delegate = self
                addTaskVC.tableIndex = indexPath.row
            }
            else {
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.taskLabel.text = todoList[indexPath.row].todoTitle
        cell.taskCategory.text = todoList[indexPath.row].todoCategory
        cell.taskTime.text = todoList[indexPath.row].todoDeadline
        return cell
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todoist list"
        self.tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditToSegue", sender: indexPath);
    }
}

