//
//  TeamCell.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var observedIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.observedIcon.image = UIImage(named: "star_orange")
        }
        else {
            self.observedIcon.image = UIImage(named: "star_gray")
        }
    }
    
    func configureFor(_ name: String) {
        self.nameLabel.text = name
    }

}
