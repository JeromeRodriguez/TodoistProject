//
//  ViewController.swift
//  Todoist
//
//  Created by Jerome Rodriguez on 29/6/19.
//  Copyright © 2019 Jerome Rodriguez. All rights reserved.
//

import UIKit

protocol AddTaskViewControllerDelegateProtocol {
    func sendDataToTableView(titleToSend: String, categoryToSend: String, dateToSend: String, segueViaAdd: Bool, tableIndex: Int)
}

class AddTaskViewController: UIViewController {
    
    enum Categories: String {
        case people = "People"
        case call = "Call"
        case shop = "Shop"
        case flight = "Flight"
        case unknown = ""
    }
    
    var categories = Categories.call
    var delegate: AddTaskViewControllerDelegateProtocol?
    let dateFormatter = DateFormatter()
    var taskLabel: String?
    var taskCategory = ""
    var taskTime: String? 
    var dateSet: Date = Date()
    var segueIsViaAdd = true
    var tableIndex = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New todo"
        todoTitleText.text = taskLabel

        if let taskTime = taskTime {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateSet = dateFormatter.date(from: taskTime)!
            todoDate.setDate(dateSet, animated: false)
            segueIsViaAdd = false
            todoCategory.selectedSegmentIndex = categoryToSegmentConverter(category: taskCategory)
            
        } else {
            todoDate.setDate(Date.init(), animated: false)
            todoCategory.selectedSegmentIndex = 0
            segueIsViaAdd = true
        }
    }
    
    @IBOutlet weak var todoCategory: UISegmentedControl!
    
    @IBOutlet weak var todoTitleText: UITextField!
    
    @IBOutlet weak var todoDate: UIDatePicker!
    
    @IBAction func doneButton(_ sender: UIButton) {
        if let delegate = self.delegate {
            let titleToSend = todoTitleText.text
            let categoryToSend = segmentToCategoryConverter(segment: todoCategory.selectedSegmentIndex)
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateToSend = dateFormatter.string(from: todoDate.date)
            delegate.sendDataToTableView(titleToSend: titleToSend!, categoryToSend: categoryToSend, dateToSend: dateToSend, segueViaAdd: segueIsViaAdd, tableIndex: tableIndex)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func categoryToSegmentConverter(category: String) -> Int {
        var segmentIndex = 0
        switch category {
        case Categories.people.rawValue:
            segmentIndex = 0
        case Categories.call.rawValue:
            segmentIndex = 1
        case Categories.shop.rawValue:
            segmentIndex = 2
        case Categories.flight.rawValue:
            segmentIndex = 3
        default:
            segmentIndex = -1
        }
        return segmentIndex
    }
    
    func segmentToCategoryConverter(segment: Int) -> String {
        var category = Categories.people
        switch segment {
        case 0:
            category = .people
        case 1:
            category = .call
        case 2:
            category = .shop
        case 3:
            category = .flight
        default:
            category = .unknown
        }
        return category.rawValue
    }
}

