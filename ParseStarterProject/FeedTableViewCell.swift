//
//  FeedTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Daniel J Janiak on 10/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var postedImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!

        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
