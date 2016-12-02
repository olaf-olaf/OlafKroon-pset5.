//
//  DetailViewController.swift
//  ToDo2
//
//  Created by Olaf Kroon on 28/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var insertDetail: UITextField!
    @IBOutlet weak var addDetail: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var detailObject = ToDoList()

   
    
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return amount of elements in the toDoItems array of detailobject
        
        return detailObject.toDoItems.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        cell.check.isOn = detailObject.toDoItems[indexPath.row].check
        cell.showDetail.text = detailObject.toDoItems[indexPath.row].detail
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            try! ToDoManager.sharedInstance.deleteDetail(indexPath: indexPath.row, title: detailObject.title)
            self.tableView.reloadData()
        }
        
    }
    
    


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    // If button is pressed, insert textfield into database
    @IBAction func detailToDataBase(_ sender: Any) {
        if addDetail.isTouchInside {
            
            // Function to insert detail into database
            try! ToDoManager.sharedInstance.insertDetail(detail: insertDetail.text! , title: detailObject.title)
        }
        tableView.reloadData()
    }
    
    
    // When the user quits the app encode state.
    override func encodeRestorableState(with coder: NSCoder) {
        
        if let toDoItem = insertDetail.text {
            coder.encode(toDoItem, forKey: "toDoItem")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    // When the user opens the app. Decode state.
    override func decodeRestorableState(with coder: NSCoder) {
        
        if let toDoItem = coder.decodeObject(forKey: "toDoItem") as? String {
            print (toDoItem)
            insertDetail.text = toDoItem
        }
        
        super.decodeRestorableState(with: coder)
        
        
    }
}

// Restore view.
extension DetailViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any],
                               coder: NSCoder) -> UIViewController? {
        let vc = DetailViewController()
        return vc
    }
}




