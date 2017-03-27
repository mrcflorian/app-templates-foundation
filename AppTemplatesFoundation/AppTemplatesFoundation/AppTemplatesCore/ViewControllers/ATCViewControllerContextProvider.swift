//
//  ATCViewControllerContextProvider.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

public enum ATCViewControllerAPIResponseType {
    case json
    case rss
    case none
}

public protocol ATCViewControllerContextProvider {
    func urlEndpointPath() -> String
    func extraParameters() -> [String: String]
    func apiResponseType() -> ATCViewControllerAPIResponseType
}
