//
//  ATCLiquidCollectionViewController.swift
//  NewsReader
//
//  Created by Florian Marcu on 3/21/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

class ATCLiquidCollectionViewController<T: ATCBaseModel>: ATCWordpressPostCollectionViewController<T>, ATCLiquidLayoutDelegate {

    public required init() {
        let layout = ATCLiquidCollectionViewLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewLayout(with: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        fatalError("ATCLiquidLayoutDelegate must be implemented by subclasses")
    }

    func collectionView(collectionView: UICollectionView, widthForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        fatalError("ATCLiquidLayoutDelegate must be implemented by subclasses")
    }

    // MARK: - Private
    fileprivate func updateCollectionViewLayout(with size: CGSize) {
        if let layout = collectionView?.collectionViewLayout as? ATCLiquidCollectionViewLayout {
            layout.invalidateLayout()
        }
    }
}
