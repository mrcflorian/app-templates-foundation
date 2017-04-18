//
//  ATCRSSFeedCollectionViewController.swift
//  NewsReader
//
//  Created by Florian Marcu on 3/26/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import AlamofireRSSParser
import UIKit

class ATCRSSFeedCollectionViewController<T: ATCBaseModel & ATCRSSItemBaseModel & NSCoding>: ATCCollectionViewController<T> {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = urlEndpointPath() {
            apiManager?.retrieveRSSFeed(urlPath: path, parameters: [:], completion: { (rssFeed: RSSFeed?, status: ATCNetworkResponseStatus) in
                if let objects = rssFeed?.items.map({ T(rssItem: $0) }) {
                    self.streamObjects = objects
                } else {
                    // TODO: Error case
                }
            })
        }
    }
}
