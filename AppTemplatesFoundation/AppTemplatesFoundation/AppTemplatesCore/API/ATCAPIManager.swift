//
//  ATCAPIManager.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import AlamofireRSSParser

public class ATCAPIManager {

    fileprivate let networkingMananger = ATCNetworkingManager()

    func retrieveObjectFromJSON<T: ATCBaseModel>(urlPath: String, parameters: [String:String]?, completion: @escaping (_ object: T?, _ status: ATCNetworkResponseStatus) -> Void) {
        networkingMananger.getJSONResponse(path: urlPath, parameters: parameters) { (jsonData: Any?, status: ATCNetworkResponseStatus) in
            if let jsonDict = jsonData as? [String: Any] {
                completion(T(JSON: jsonDict), status)
            } else {
                completion(nil, status)
            }
        }
    }

    func retrieveListFromJSON<T: ATCBaseModel>(urlPath: String, parameters: [String:String]?, completion: @escaping (_ objects: [T]?, _ status: ATCNetworkResponseStatus) -> Void) {
        networkingMananger.getJSONResponse(path: urlPath, parameters: parameters) { (jsonData: Any?, status: ATCNetworkResponseStatus) in
            if let jsonArray = jsonData as? [[String: Any]] {
                completion(jsonArray.flatMap{T(JSON: $0)}, status)
            } else {
                completion(nil, status)
            }
        }
    }

    func retrieveRSSFeed(urlPath: String, parameters: [String:String]?, completion: @escaping (_ rssFeed: RSSFeed?, _ status: ATCNetworkResponseStatus) -> Void) {
        networkingMananger.getRSSFeedResponse(path: urlPath, parameters: parameters) { (rssFeed: RSSFeed?, status: ATCNetworkResponseStatus) in
            completion(rssFeed, status)
        }
    }
}
