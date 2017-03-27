//
//  ATCTableViewController.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import AlamofireRSSParser
import UIKit

open class ATCCollectionViewController<T: ATCBaseModel>: UICollectionViewController, ATCViewControllerContextProvider {

    var apiManager: ATCAPIManager?
    var streamObjects = [T]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        apiManager = ATCAPIManager(urlPath: self.urlEndpointPath())

        switch self.apiResponseType() {
        case .json:
            // TODO: Consolidate this call with the one below
            apiManager?.retrieveListFromJSON(parameters: self.extraParameters(), completion: { (objects: [T]?, status: ATCNetworkResponseStatus) in
                if let objects = objects {
                    self.didReceiveStreamObjects(objects: objects)
                } else {
                    // TODO: Error case
                }
            })
        case .rss:
            apiManager?.retrieveRSSFeed(parameters: self.extraParameters(), completion: { (rssFeed: RSSFeed?, status: ATCNetworkResponseStatus) in
                if let objects = rssFeed?.wordpressObjects() {
                    //self.didReceiveStreamObjects(objects: objects as! [ATCBaseModel])
                } else {
                    // TODO: Error case
                }
            })
        case .none:
            break
        }
    }

    public func object(at indexPath: IndexPath) -> T? {
        if (indexPath.row < streamObjects.count) {
            return streamObjects[indexPath.row]
        }
        return nil
    }

    // MARK: UICollectionViewDataSource

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streamObjects.count
    }

    // MARK: ATCViewControllerContextProvider
    public func urlEndpointPath() -> String {
        return ""
    }

    public func extraParameters() -> [String: String] {
        return [:]
    }

    public func apiResponseType() -> ATCViewControllerAPIResponseType {
        return .json
    }

    // MARK: - Private

    fileprivate func didReceiveStreamObjects(objects: [T]) {
        streamObjects += objects
        self.collectionView?.reloadData()
    }
}
