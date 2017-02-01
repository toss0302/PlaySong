//
//  TrackCell.swift
//  FirstSwift
//
//  Created by BigWin on 2/1/17.
//  Copyright © 2017 BigWin. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet var playIcon: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
