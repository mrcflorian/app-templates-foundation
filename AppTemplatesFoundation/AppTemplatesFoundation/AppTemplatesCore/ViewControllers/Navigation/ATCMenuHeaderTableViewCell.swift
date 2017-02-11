//
//  ATCMenuHeaderTableViewCell.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/11/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Kingfisher
import UIKit

open class ATCMenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet var avatarView: UIImageView!
    open func configureCell(imageURLString: String) {
        let imageURL = URL(string: imageURLString)
        avatarView.kf.setImage(with: imageURL)
        avatarView.layer.cornerRadius = 25
        avatarView.clipsToBounds = true
    }
}
