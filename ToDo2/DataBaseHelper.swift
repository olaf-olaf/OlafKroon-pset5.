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
            // Create a table for lists
            try db!.run(titleList.create(ifNotExists: true) {
                
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(dataToDo)
                
            })
            
            // create a table for details
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
    
    
    // INSERT FUNCTIONS
    
    // Insert a element into the List table.
    func createList(toDo: String) throws {
        let listItem = ToDoList()
        let insertToDo = titleList.insert(self.dataToDo <- toDo)
        
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
    
       
       
    // READ FUNCTIONS
        
    // Return a toDo with an id that corresponds to the tablerow
    func readList(index: Int) throws -> String? {
        var result: String?
        var count = 0
        
        do {
            
            for row in try db!.prepare(titleList) {
                if count == index {
                    result = row[dataToDo]
                }
                count = count + 1
            }
            
        } catch {
            throw error
        }
        return result
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
        
    // Return a id from titleList
    func readlistId(index: Int) throws -> Int? {
        var result: Int?
        var count = 0
            
        do {
            for row in try db!.prepare(titleList) {
                if count == index {
                    result = row[id]
                }
                count = count + 1
            }
        } catch {
            throw error
        }
        return result
        }
    
    // Return all the details that correspond with toDo
        
    // DELETE FUNCTIONS
    
    // Delete a list row where id = rowid.
    // ALLE CORRESPONDERENDE DETAILS MOETEN OOK WORDEN VERWIJDERD
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
            //titles.remove(at: indexPath.row)
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
    }
        
        
    // AMOUNT OF ROWS FUNCTIONS
    
    // Get the amount of rows in list table
//    func amountOfListRows() throws -> Int? {
//        var count = Int()
//        do {
//            for _ in try db!.prepare(titleList) {
//                count = count + 1
//            }
//        } catch {
//            throw error
//        }
//        return count
//    }
//    
//    // Get the amount of rows in detail table
//    func amountOfDetailRows() throws -> Int? {
//        var count = Int()
//        do {
//            for _ in try db!.prepare(detailList) {
//                count = count + 1
//            }
//        } catch {
//            throw error
//        }
//        return count
//    }

    

