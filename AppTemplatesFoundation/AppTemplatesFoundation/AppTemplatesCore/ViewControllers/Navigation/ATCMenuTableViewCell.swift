//
//  ATCMenuTableViewCell.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/10/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

open class ATCMenuTableViewCell: UITableViewCell {

    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var label: UILabel!

    public func configure(item: ATCNavigationItem) {
        itemImageView.image = item.image
        label.text = item.title
    }
}
