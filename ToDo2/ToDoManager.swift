//
//  ToDoManager.swift
//  ToDo2
//
//  Created by Olaf Kroon on 28/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import Foundation

class ToDoManager {
    
    private let db = DatabaseHelper()
    
    static let sharedInstance = ToDoManager()
    
    // An array of toDolist objects
    var toDoLists = [ToDoList]()
    
    private init(){
        
    }
    
    //Check contents
    func checkContents() {
        for item in toDoLists {
            print("item",item.title)
        }
    }
    
    //Functie die read
    func read() throws {
        do {
            try db!.read()
        } catch {
            throw error
        }
    }
    
    
    
    
    //Functies die write
    
    //create tableList
    func insertList(item: String) throws {
        do {
            try db!.createList(toDo: item)
        } catch {
            throw error
        }
    }
    
    //create tableDetail
    func insertDetail(detail: String, title: String) throws {
        
        do {
            try db!.createDetail(detail: detail, title: title)
            
        } catch {
            throw error
        }
        
    }
    
    //delete tableList
    func deleteList(indexPath: Int) throws {
        do {
            try db!.deleteList(index: indexPath)
        } catch {
            throw error
        }
    }
    
    //delete tabledetail
    func deleteDetail(indexPath: Int, title: String) throws {
        do {
            try db!.deleteDetail(index: indexPath, title: title)
        } catch {
            throw error
        }
    }
}
