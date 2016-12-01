//
//  ToDoItem.swift
//  ToDo2
//
//  Created by Olaf Kroon on 30/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import Foundation

class ToDoItem: NSCopying {
    
    
    var title = String()
    var check = Bool()
    var detail = String()
    
    
    init(){
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ToDoItem()
        return copy
    }
}
