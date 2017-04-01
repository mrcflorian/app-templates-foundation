//
//  ATCTableViewController.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

open class ATCCollectionViewController<T: ATCBaseModel>: UICollectionViewController, ATCRemoteHostContextProvider {

    var apiManager: ATCAPIManager?

    var streamObjects = [T]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        if let path = urlEndpointPath() {
            apiManager = ATCAPIManager(urlPath: path)
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

    // MARK: ATCRemoteHostContextProvider

    public func urlEndpointPath() -> String? {
        return nil
    }
}
