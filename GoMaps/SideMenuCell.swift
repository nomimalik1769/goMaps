//
//  SideMenuCell.swift
//  GoMaps
//
//  Created by Admin on 29/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit
import  GoogleSignIn

class SideMenuCell: UITableViewCell{
   @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
     @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var backImage: UIImageView!
     @IBOutlet weak var menuImage: UIImageView!
   @IBOutlet weak var SignIN: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfilePic.isHidden = true
        ProfileName.isHidden = true
        let image: UIImage = UIImage.init(named: "user")!
        ProfilePic.layer.borderWidth = 1.0
        ProfilePic.layer.masksToBounds = false
        ProfilePic.layer.borderColor = UIColor.white.cgColor
        ProfilePic.layer.cornerRadius = image.size.width/2
        ProfilePic.clipsToBounds = true
    }
}
