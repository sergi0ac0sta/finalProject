//
//  TableViewCell.swift
//  FinalProject
//
//  Created by Sergio A Acosta on 3/20/17.
//  Copyright © 2017 Sergio Acosta. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
