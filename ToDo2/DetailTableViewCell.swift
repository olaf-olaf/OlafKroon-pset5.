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
    @IBOutlet weak var detail: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
