//
//  MasterViewController.swift
//  ToDo2
//
//  Created by Olaf Kroon on 28/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    // Dit moet de array worden uit je Manager.
    var objects: [String] = []
    var addListItem = String()
    //var counter = Int()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        try!    ToDoManager.sharedInstance.read()
        //ToDoManager.sharedInstance.checkContents()
        print(ToDoManager.sharedInstance.toDoLists)
        

    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        
        let alert = UIAlertController(title: "Enter a to do list.", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //self.addListItem = textField!.text!
            //self.objects.append(self.addListItem)
            //self.counter = self.objects.count
            if try! ToDoManager.sharedInstance.insertList(item: textField!.text!) == false {
                print("FALSE")
                let alert = UIAlertController(title: "You already have that list", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
            self.tableView.reloadData()
    
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Segues
    
    // SEGUE object that is in the corresponding row array

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            // Segue object
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = ToDoManager.sharedInstance.toDoLists[indexPath.row]
                print("segueing: ",object.title)
                let DetailViewController = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                DetailViewController.detailObject = object
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if(segue.identifier == "yourIdentifierInStoryboard") {
//            
//            let yourNextViewController = (segue.destinationViewController as yourNextViewControllerClass)
//            yourNextViewController.value = yourValue
    


    // MARK: - Table View

    //override func numberOfSections(in tableView: UITableView) -> Int {
       // return 1
   // }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the amount of elements in the toDolists array of the shared instance.
        print("NUMBERROWS: ", ToDoManager.sharedInstance.toDoLists.count)
        return ToDoManager.sharedInstance.toDoLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MasterTableViewCell
        
        // Insert title string of every ToDolist item in the toDolists array into a cell.
        cell.title.text! = ToDoManager.sharedInstance.toDoLists[indexPath.row].title
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            try! ToDoManager.sharedInstance.deleteList(indexPath: indexPath.row)
            self.tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

