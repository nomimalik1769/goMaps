//
//  PlaceViewCell.swift
//  GoMaps
//
//  Created by Admin on 23/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit

class PlaceViewCell: UITableViewCell {

    @IBOutlet weak var placeimage: UIImageView!
    @IBOutlet weak var placename: UILabel!
    @IBOutlet weak var placeline: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
