//
//  ATCNavigationController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/11/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Material
import UIKit

open class ATCNavigationController: NavigationController, UINavigationControllerDelegate {
    fileprivate var menuButton: IconButton!
    override open func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareStatusBar()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        topViewController?.navigationItem.leftViews = [menuButton]
    }

    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        prepareNavigationBar()
    }
}

extension ATCNavigationController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
    }

    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent

        // Access the statusBar.
        //        statusBar.backgroundColor = Color.green.base
    }

    fileprivate func prepareNavigationBar() {
        topViewController?.navigationItem.title = topViewController?.title
    }
}

extension ATCNavigationController {
    @objc
    fileprivate func handleMenuButton() {
        navigationDrawerController?.toggleLeftView()
    }
}
