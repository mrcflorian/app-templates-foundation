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

        let first = FirstViewController(nibName: "FirstViewController", bundle: nil)
        first.title = "ZZZZ"

        let item1 = ATCNavigationItem(title: "XXX", viewController: first, image: UIImage(named: "twitter-icon"))
        let item2 = ATCNavigationItem(title: "YYY", viewController: UIViewController(), image: UIImage(named: "facebook-icon"))
        let items = [item1, item2]
        let vc = ATCHostViewController(style: .tabBar, items: items)
        self.present(vc, animated: true, completion: nil)

        first.tabBarController?.title = "adsadas"
    }
}

