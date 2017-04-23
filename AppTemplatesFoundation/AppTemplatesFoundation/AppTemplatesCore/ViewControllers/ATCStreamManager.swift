//
//  ATCStreamManager.swift
//  WordpressApp
//
//  Created by Florian Marcu on 4/20/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Foundation

public protocol ATCStreamManagerDataSource: class {
    func loadMoreEndpointQuery(for page: Int) -> String
    func loadTopEndpointQuery() -> String
}

public protocol ATCStreamManagerDelegate: class {
    func streamManagerDidFinishLoadingBottom(streamEnded: Bool)
    func streamManagerDidFinishLoadingTop()
    func streamManagerDidFail()
}

public class ATCStreamManager<T: ATCBaseModel & NSCoding & Equatable> {
    var streamObjects: [T] = []
    var currentPage: Int = 1
    let apiManager: ATCAPIManager
    let urlEndpointPath: String

    private var isLoadingTop = false
    private var isLoadingBottom = false
    private var bottomStreamLoadingEnded = false

    weak var delegate: ATCStreamManagerDelegate?
    weak var dataSource: ATCStreamManagerDataSource?

    init(endpointPath: String, apiManager: ATCAPIManager) {
        self.urlEndpointPath = endpointPath
        self.apiManager = apiManager
    }

    func loadTop() {
        if isLoadingTop {
            return
        }
        if let dataSource = dataSource {
            let loadTopPath = urlEndpointPath + dataSource.loadTopEndpointQuery()
            isLoadingTop = true
            apiManager.retrieveListFromJSON(urlPath: loadTopPath, parameters: [:], completion: { (objects : [T]?, status) in
                objects?.forEach({
                    if !self.findStreamObject(object: $0) {
                        self.streamObjects = [$0] + self.streamObjects
                    }
                })
                self.delegate?.streamManagerDidFinishLoadingTop()
                self.isLoadingTop = false
            })
        } else {
            self.delegate?.streamManagerDidFail()
        }
    }

    func loadBottom() {
        if isLoadingBottom || bottomStreamLoadingEnded{
            return
        }
        if let dataSource = dataSource {
            let loadBottomPath = urlEndpointPath + dataSource.loadMoreEndpointQuery(for: self.currentPage)
            isLoadingBottom = true
            apiManager.retrieveListFromJSON(urlPath: loadBottomPath, parameters: [:], completion: { (objects : [T]?, status) in
                self.currentPage += 1
                objects?.forEach({
                    if !self.findStreamObject(object: $0) {
                        self.streamObjects = self.streamObjects + [$0]
                    }
                })
                if ((objects?.count ?? 0) == 0) {
                    self.bottomStreamLoadingEnded = true
                }
                self.delegate?.streamManagerDidFinishLoadingBottom(streamEnded: self.bottomStreamLoadingEnded)
                self.isLoadingBottom = false
            })
        } else {
            self.delegate?.streamManagerDidFail()
        }
    }

    private func findStreamObject(object: T) -> Bool {
        return streamObjects.filter({object == $0}).count > 0
    }
}
