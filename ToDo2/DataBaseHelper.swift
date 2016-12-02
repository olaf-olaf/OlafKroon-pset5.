//
//  DataBaseHelper.swift
//  ToDo2
//
//  Created by Olaf Kroon on 28/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    private let titleList = Table("titlelist")
    private let detailList = Table("detailList")
    private let id = Expression<Int>("id")
    private let dataToDo = Expression<String?>("toDo")
    private let dataDetail = Expression<String?>("detail")
    private let dataCheck = Expression<Bool>("check")
    
    private var db: Connection?
    
    init?() {
        do{
            try setupDatabase()
        } catch {
            print (error)
            return nil
        }
    }
    
    private func setupDatabase() throws{
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            throw error
        }
    }
    
    private func createTable() throws {
        
        do {
            // Create a table for lists.
            try db!.run(titleList.create(ifNotExists: true) {
                
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(dataToDo, unique: true)
                
            })
            
            // Create a table for details.
            try db!.run(detailList.create(ifNotExists: true) {
                
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(dataDetail)
                t.column(dataCheck)
                t.column(dataToDo)
                
            })
        } catch{
            throw error
        }
    }
    
    
    
    // Insert a element into the List table.
    func createList(toDo: String) throws -> Bool {
        let listItem = ToDoList()
        let insertToDo = titleList.insert(self.dataToDo <- toDo)
        var unique = true
        
        // If title is in table do not add a duplicate
            for row in try db!.prepare(titleList) {
                if row[dataToDo] == toDo {
                    unique = false
                }
            }
        
        if unique == false {
            return false
        } else {
            
            do {
            
                // Insert data into database.
                _ = try db!.run(insertToDo)
                print("insertion: ", toDo)
            
                // Update objects.
                listItem.title = toDo
                print("INSERTTEXT",listItem.title.copy())
                ToDoManager.sharedInstance.toDoLists.append(listItem)
            } catch {
                throw error
            }
            return true
        }
    }
    
    
    // Insert a element into the Detail table.
    func createDetail(detail: String, title: String) throws {
        let item = ToDoItem()
        let insertData = detailList.insert(self.dataDetail <- detail,self.dataToDo <- title, self.dataCheck <- false)
       
        
        do {
            // Insert data into the Database
            _ = try db!.run(insertData)
            
            //Update objects
            item.check = false
            item.title = title
            item.detail = detail
            
            for element in ToDoManager.sharedInstance.toDoLists{
                if element.title == title {
                    element.toDoItems.append(item)
                }
            }
        } catch {
            throw error
        }
    }
    
   
    // Read the entire database
    func read() throws {
        do {
            
            for row in try db!.prepare(titleList) {
                // initialise ToDoList object
                let listItem = ToDoList()
                
                // for every row in titleList listitem.title is toDoList.
                listItem.title = row[dataToDo]!
                
                for rowSecond in try db!.prepare(detailList) {
                    let toDoItem = ToDoItem()
                    
                    // If a row in detaillist has a dataToDo that corresponds with listitem.title
                    // update all values and add a copy to listitem.toDoItemsa array.
                    if listItem.title == rowSecond[dataToDo] {
                        toDoItem.title = rowSecond[dataToDo]!
                        toDoItem.check = rowSecond[dataCheck]
                        toDoItem.detail = rowSecond[dataDetail]!
                        listItem.toDoItems.append(toDoItem)
                    }
                }
                // append listitemen to the array in ToDoManager
                ToDoManager.sharedInstance.toDoLists.append(listItem)
            }
            
        } catch {
            throw error
        }
            
    }
        
    
        
    // DELETE FUNCTIONS
    
    // Delete a list row where id = rowid.
    func deleteList(index: Int) throws {
        var rowId = Int()
        var rowTitle = String()
        
        var count = 0
       
        do{
            for checkId in try db!.prepare(titleList) {
                if count == index {
                    rowId = checkId[id]
                    rowTitle = checkId[dataToDo]!
                }
                count = count + 1
            }
            // Delete the list
            let locationTitleList = titleList.filter(id == rowId)
            let locationDetailList = detailList.filter(dataToDo == rowTitle)

            // Delete items from both tables in database
            try db!.run(locationTitleList.delete())
            try db!.run(locationDetailList.delete())
            
            // Delete objects from TodoManager.toDoLists
            ToDoManager.sharedInstance.toDoLists.remove(at: index)
            
        } catch {
            
            throw error
        }
    }
    
    // delete detail where id = rowid
    func deleteDetail(index: Int, title: String) throws {
    var count = 0
    var rowId = Int()
        
    do {
        for checkId in try db!.prepare(detailList) {
            if count == index {
                rowId = checkId[id]
            }
            count = count + 1
        }
        // Delete the row from database
        let locationList = detailList.filter(id == rowId)
        try db!.run(locationList.delete())
            
        // Delete object from array
        for element in ToDoManager.sharedInstance.toDoLists{
            if element.title == title {
                element.toDoItems.remove(at: index)
            }
        }
        } catch {
            throw error
        }
    }
    
    
    func updateCheck(detail: String, currentState: Bool) throws {
        var title = String()
        print("IN FUNCTION", currentState)
        
        do {
            // get the title
            for row in try db!.prepare(detailList) {
                if row[dataDetail] == detail {
                    title = row[dataToDo]!
                    print("TITLE: ", title)
                }
            }
        // Update objects
            if currentState == false {
                print ("IN IF FALSE")
                for object in ToDoManager.sharedInstance.toDoLists{
                    if object.title == title {
                        print("FOUND OBJECT")
                        for secondObject in object.toDoItems {
                            if secondObject.check == true && secondObject.detail == detail && secondObject.title == title {
                                print ("UPDATING OBJECT")
                                secondObject.check = false
                                print("CHECK",secondObject.check)
                            }
                        }
                    }
                }
            // Updata database
            let updater = detailList.filter(dataDetail == detail && dataToDo == title)
                 try db!.run(updater.update(dataCheck <- false))
                print ("UPDATE")
                
            }
            if currentState == true {
                print("IN IF TRUE")
                
                // Update objects
                for object in ToDoManager.sharedInstance.toDoLists{
                    if object.title == title {
                        print("FOUND OBJECT")
                        for secondObject in object.toDoItems {
                            if secondObject.check == false && secondObject.detail == detail && secondObject.title == title {
                                print ("UPDATING OBJECT")
                                secondObject.check = true
                                print("CHECK",secondObject.check)
                            }
                        }
                    }
                }
                // Updata database
                let updater = detailList.filter(dataDetail == detail && dataToDo == title)
                try db!.run(updater.update(dataCheck <- true))
                print ("UPDATE")

            }
        
        } catch {
            throw error
        }
    }
    
}
        
        


    

