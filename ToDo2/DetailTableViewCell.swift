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
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // If a switched is pressed update data in sharedInstance and database.
    @IBAction func checkOff(_ sender: Any) {
        if check.isEnabled{
        try! ToDoManager.sharedInstance.updateCheckSwitch(detail: showDetail.text!, currentState: check.isOn)
        DetailTableViewCell.load()
        }
    }
    
    
}
