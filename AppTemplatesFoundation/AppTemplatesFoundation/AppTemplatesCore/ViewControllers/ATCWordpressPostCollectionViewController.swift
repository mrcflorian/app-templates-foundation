//
//  ATCWordpressPostCollectionViewController.swift
//  NewsReader
//
//  Created by Florian Marcu on 3/26/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

class ATCWordpressPostCollectionViewController<T: ATCBaseModel>: ATCCollectionViewController<T> {

    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager?.retrieveListFromJSON(parameters: [:], completion: { (objects : [T]?, status) in
            if let objects = objects {
                self.streamObjects = objects
            }
        })
    }
}
