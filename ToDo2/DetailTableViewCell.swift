//
//  DetailTableViewCell.swift
//  ToDo2
//
//  Created by Olaf Kroon on 29/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var check: UISwitch!
    @IBOutlet weak var showDetail: UILabel!
    
    //var tapped: ((cell) -> Void)?
   
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkOff(_ sender: Any) {
        
       // tapped?(self)
        
        
        if check.isEnabled{
        print("BEFOREFUNC", check.isOn)
        try! ToDoManager.sharedInstance.updateCheckSwitch(detail: showDetail.text!, currentState: check.isOn)
        DetailTableViewCell.load()
        }
    }
    
    
}
