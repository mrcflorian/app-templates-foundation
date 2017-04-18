//
//  ATCTableViewController.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Foundation
import UIKit

open class ATCCollectionViewController<T: ATCBaseModel & NSCoding>: UICollectionViewController, ATCRemoteHostContextProvider {

    private let archiveItemsURL = FileManager().urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(String(describing: ATCCollectionViewController.self))

    var apiManager: ATCAPIManager?

    var streamObjects = [T]() {
        didSet {
            self.collectionView?.reloadData()
            saveCurrentObjectsToDiskIfNeeded()
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        loadCurrentObjectsFromDisk()

        apiManager = ATCAPIManager()
        if let path = urlEndpointPath() {
            apiManager?.retrieveListFromJSON(urlPath: path, parameters: [:], completion: { (objects : [T]?, status) in
                if let objects = objects {
                    self.streamObjects = objects
                }
            })
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

    // MARK: Private
    private func saveCurrentObjectsToDiskIfNeeded() {
        let success = NSKeyedArchiver.archiveRootObject(self.streamObjects, toFile: archiveItemsURL.path)
        if (!success) {
            print("Unable to write to disk")
        }
    }

    private func loadCurrentObjectsFromDisk() {
        if let streamObjects = NSKeyedUnarchiver.unarchiveObject(withFile: archiveItemsURL.path) as? [T] {
            self.streamObjects = streamObjects
        }
    }
}
