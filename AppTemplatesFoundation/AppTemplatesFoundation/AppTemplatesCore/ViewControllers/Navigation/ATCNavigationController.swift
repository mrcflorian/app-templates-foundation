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
    fileprivate var topNavigationRightViews: [UIView] = [UIView]()
    fileprivate var topNavigationLeftImage: UIImage?

    public init(rootViewController: UIViewController, topNavigationRightViews: [UIView], topNavigationLeftImage: UIImage?) {
        super.init(rootViewController: rootViewController)
        self.topNavigationRightViews = topNavigationRightViews
        self.topNavigationLeftImage = topNavigationLeftImage
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareStatusBar()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        prepareNavigationBar()
    }
}

extension ATCNavigationController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: topNavigationLeftImage)
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
    }

    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
    }

    fileprivate func prepareNavigationBar() {
        topViewController?.navigationItem.title = topViewController?.title

        if self.viewControllers.count <= 1 {
            topViewController?.navigationItem.leftViews = [menuButton]
            topViewController?.navigationItem.rightViews = topNavigationRightViews
            topViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

extension ATCNavigationController {
    @objc
    fileprivate func handleMenuButton() {
        navigationDrawerController?.toggleLeftView()
    }
}
