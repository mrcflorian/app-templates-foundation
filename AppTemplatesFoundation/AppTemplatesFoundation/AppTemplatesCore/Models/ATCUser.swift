//
//  ATCUser.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import ObjectMapper

public class ATCUser: ATCBaseModel {

    var username: String?
    var email: String?
    var firstName: String?
    var lastName: String?

    public required init?(map: Map) {

    }

    public func mapping(map: Map) {
        username      <- map["username"]
        email         <- map["email"]
        firstName     <- map["first_name"]
        lastName      <- map["last_name"]
    }
}
