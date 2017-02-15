//
//  LogoutCell.swift
//  FeedbackStar
//
//  Created by Vin on 2016/12/16.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class LogoutCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
