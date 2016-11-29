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
    
    private let toDoList = Table("list")
    private let detailList = Table("detailList")
    private let id = Expression<Int>("id")
    private let toDo = Expression<String?>("toDo")
    private let detail = Expression<String?>("detail")
    private let check = Expression<Bool>("check")
    
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
            try db!.run(toDoList.create(ifNotExists: true) {
                
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(toDo)
                
            })
            
            // create a table for details
            try db!.run(detailList.create(ifNotExists: true) {
                
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(detail)
                t.column(check)
                t.column(toDo)
                
            })
        } catch{
            throw error
        }
    }
    
    
    // INSERT FUNCTIONS
    
    // Insert a element into the List table.
    func createList(toDo: String) throws {
        let insertToDo = toDoList.insert(self.toDo <- toDo)
        
        do {
            let rowId = try db!.run(insertToDo)
            print("ROWID: ", rowId)
        } catch {
            throw error
        }
    }
    
    
    // Insert a element into the Detail table.
    func createDetail(detail: String, title: String) throws {
        let insertDetail = detailList.insert(self.detail <- detail)
        let insertTitle = detailList.insert(self.toDo <- title)
        
        do {
            // GEBEURT DIT IN DEZELFDE RIJ?
            let rowId = try db!.run(insertDetail)
            let rowIdTwo = try db!.run(insertTitle)
            print (rowId)
            print(rowIdTwo)
        } catch {
            throw error
        }
        
       
       
    // READ FUNCTIONS
        
    // Return a toDo with an id that corresponds to the tablerow
    func readList(index: Int) throws -> String? {
        var result: String?
        var count = 0
        
        do {
            
            for row in try db!.prepare(toDoList) {
                if count == index {
                    result = row[toDo]
                }
                count = count + 1
            }
            
        } catch {
            throw error
        }
        return result
    }
        
    // Return a id from toDolist
    func readlistId(index: Int) throws -> Int? {
        var result: Int?
        var count = 0
            
        do {
            for row in try db!.prepare(toDoList) {
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
    
    // Delete a row where id = rowid.
    func deleteList(index: Int) throws {
        var rowId = Int()
        
        var count = 0
       
        do{
            for checkId in try db!.prepare(toDoList) {
                if count == index {
                    rowId = checkId[id]
                }
                count = count + 1
            }
            // Delete the list
            let locationList = toDoList.filter(id == rowId)
//            let locationDetail = detailList.filter(detailId == rowId)
            
            try db!.run(locationList.delete())
            //try db!.run(locationDetail.delete())
            
        } catch {
            
            throw error
        }
        
    // delete detail where id = rowid
    func deleteDetail(index: Int) throws {
        var count = 0
        rowId = Int()
        do{
            for checkId in try db!.prepare(detailList) {
                if count == index {
                    rowId = checkId[id]
                }
                count = count + 1
            }
            // Delete the list
            let locationList = detailList.filter(id == rowId)
            try db!.run(locationList.delete())
        } catch {
            throw error
        }
        }
    }
        
        
    // AMOUNT OF ROWS FUNCTIONS
    
    // Get the amount of rows in list table
    func amountOfListRows() throws -> Int? {
        var count = Int()
        do {
            for _ in try db!.prepare(toDoList) {
                count = count + 1
            }
        } catch {
            throw error
        }
        return count
    }
    
    // Get the amount of rows in detail table
    func amountOfDetailRows() throws -> Int? {
        var count = Int()
        do {
            for _ in try db!.prepare(detailList) {
                count = count + 1
            }
        } catch {
            throw error
        }
        return count
    }
}
    
}
