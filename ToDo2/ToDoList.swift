//
//  ToDoList.swift
//  ToDo2
//
//  Created by Olaf Kroon on 30/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import Foundation

class ToDoList: NSCopying {
    
    var title = String()
    var toDoItems = [ToDoItem]()
    
    init(){
        
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ToDoList()
        return copy
    }

}
