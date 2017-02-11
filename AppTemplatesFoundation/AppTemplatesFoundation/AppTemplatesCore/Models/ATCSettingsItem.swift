//
//  ATCSettings.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/11/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

public enum ATCSettingsItemStyle {
    case toggle
    case text
    case more
}

open class ATCSettingsItem {
    let style: ATCSettingsItemStyle
    let action: ((Void) -> (Void))
    let title: String

    let toggleValue: Bool?

    init(title: String, style: ATCSettingsItemStyle, action: @escaping (Void) -> (Void), toggleValue: Bool? = nil) {
        self.style = style
        self.action = action
        self.title = title
        self.toggleValue = toggleValue
    }
}
