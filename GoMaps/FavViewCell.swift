//
//  FavViewCell.swift
//  GoMaps
//
//  Created by Admin on 25/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit

class FavViewCell: UITableViewCell {
    @IBOutlet weak var starting: UILabel!
    @IBOutlet weak var ending: UILabel!
    @IBOutlet weak var startlat: UILabel!
    @IBOutlet weak var endlat: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        startlat.isHidden = true
        endlat.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
