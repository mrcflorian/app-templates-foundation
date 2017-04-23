//
//  ATCTableViewController.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Foundation
import UIKit

open class ATCCollectionViewController<T: ATCBaseModel & NSCoding & Equatable>: UICollectionViewController, ATCRemoteHostContextProvider, ATCStreamManagerDataSource, ATCStreamManagerDelegate {

    private let archiveItemsURL = FileManager().urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(String(describing: ATCCollectionViewController.self))
    private let kLoadMoreBottomDistance: CGFloat = 10.0

    private var didFinishLoadingBottom = false

    lazy var streamObjectsOnDisk: [T]? = {
        [unowned self] in
        return NSKeyedUnarchiver.unarchiveObject(withFile: self.archiveItemsURL.path) as? [T]
    }()

    lazy var streamManager: ATCStreamManager<T>? = {
        [unowned self] in
        guard let urlPath = self.urlEndpointPath() else { return nil }
        let streamManager = ATCStreamManager<T>(endpointPath: urlPath, apiManager: ATCAPIManager())
        streamManager.delegate = self
        streamManager.dataSource = self
        return streamManager
        }()

    var streamObjects: [T] {
        get {
            if let objects = self.streamManager?.streamObjects, objects.count > 0 {
                return objects
            }
            guard let objectsOnDisk = self.streamObjectsOnDisk else { return [] }
            return objectsOnDisk
        }
    }

    lazy var refreshControl = UIRefreshControl()

    override open func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.alwaysBounceVertical = true
        collectionView?.addSubview(refreshControl)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(loadTop), for: .valueChanged)

        let cellNib = UINib(nibName: "ATCLoadMoreCollectionViewCell", bundle: nil)
        collectionView?.register(cellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ATCLoadMoreCollectionViewCell")

        if let collectionView = collectionView {
            let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            collectionViewLayout?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 100)
        }

        loadMoreData()
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

    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ATCLoadMoreCollectionViewCell", for: indexPath)
        }
        fatalError("should not happen")
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if !didFinishLoadingBottom {
            return CGSize(width: collectionView.bounds.width, height: 100)
        }
        return .zero
    }

    // MARK: ATCRemoteHostContextProvider

    public func urlEndpointPath() -> String? {
        return nil
    }

    // MARK: ATCStreamManagerDelegate

    public func streamManagerDidFinishLoadingBottom(streamEnded: Bool) {
        if (streamEnded) {
            didFinishLoadingBottom = true
        }
        self.collectionView?.reloadData()
        saveCurrentObjectsToDisk()
    }

    public func streamManagerDidFinishLoadingTop() {
        self.collectionView?.reloadData()
        self.refreshControl.endRefreshing()
        saveCurrentObjectsToDisk()
    }

    public func streamManagerDidFail() {

    }

    // MARK: ATCStreamManagerDataSource

    public func loadMoreEndpointQuery(for page: Int) -> String {
        return "?page=" + String(page) + "&per_page=5"
    }

    public func loadTopEndpointQuery() -> String {
        return "?page=1&per_page=2"
    }

    // MARK: UIScrollViewDelegate
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= -kLoadMoreBottomDistance {
            self.loadMoreData()
        }
    }

    // MARK: Private

    private func loadMoreData() {
        streamManager?.loadBottom()
    }

    @objc func loadTop() {
        streamManager?.loadTop()
    }

    private func saveCurrentObjectsToDisk() {
        let success = NSKeyedArchiver.archiveRootObject(self.streamObjects, toFile: archiveItemsURL.path)
        if (!success) {
            print("Unable to write to disk")
        }
    }

    private func equalStreamObjects(objects1: [T], objects2: [T]) -> Bool {
        if (objects1.count != objects2.count) {
            return false
        }
        for i in 0 ..< objects1.count {
            if (objects1[i] != objects2[i]) {
                return false;
            }
        }
        return true
    }
}
