//
//  ViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/4/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //let vc = ATCViewControllerFactory.createLoginViewController(firebaseEnabled: AppConfiguration.isFirebaseIntegrationEnabled)

        self.view.backgroundColor = .red

        let action: (Void) -> (Void) = {
            print ("Sexyyyy")
        }
        let sItem1 = ATCSettingsItem(title: "Push notifications", style: .toggle, action: action, toggleValue: true)
        let sItem2 = ATCSettingsItem(title: "Terms & Conditions", style: .more, action: action)
        let sItem3 = ATCSettingsItem(title: "Credit card", style: .text, action: action)
        let sItems = [sItem1, sItem2, sItem3]

        let settingsVC = ATCSettingsTableViewController(settings: sItems, nibNameOrNil: nil, nibBundleOrNil: nil)
        settingsVC.title = "Settings"

        let item3 = ATCNavigationItem(title: "Settings", viewController: settingsVC, image: UIImage(named: "settings-menu-item"))

        let first = FirstViewController(nibName: "FirstViewController", bundle: nil)
        first.title = "Home"

        let item1 = ATCNavigationItem(title: "Home", viewController: first, image: UIImage(named: "home-menu-icon"))
        let item2 = ATCNavigationItem(title: "Log out", viewController: UIViewController(), image: UIImage(named: "logout-menu-item"))

        let items = [item1, item3, item2]
        let avatarURL = "https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/12801222_1293104680705553_7502147733893902564_n.jpg?oh=b151770a598fea1b2d6b8f3382d9e7c9&oe=593E48A9"
        let user = ATCUser(firstName: "Florian", lastName: "Marcu", avatarURL: avatarURL)
        let vc = ATCHostViewController(style: .sideBar, items: items, user: user)
        self.present(vc, animated: true, completion: nil)

//        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().barTintColor = .green
//        UITabBar.appearance().tintColor = .black
    }
}
