//
//  ATCNavigationViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/8/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Material
import UIKit

public enum ATCNavigationStyle {
    case tabBar
    case sideBar
}

public final class ATCNavigationItem {
    let viewController: UIViewController
    let title: String
    let image: UIImage?

    init(title: String, viewController: UIViewController, image: UIImage?) {
        self.title = title
        self.viewController = viewController
        self.image = image
    }
}

open class ATCHostViewController: UIViewController {

    let items: [ATCNavigationItem]
    let style: ATCNavigationStyle
    let avatarURL: String

    open var tabController: UITabBarController?
    open var navigationToolbarController: ATCNavigationToolbarController?
    open var menuViewController: ATCMenuTableViewController?
    open var drawerController: ATCNavigationDrawerController?

    init(style: ATCNavigationStyle, items: [ATCNavigationItem], avatarURL: String = "") {
        self.style = style
        self.items = items
        self.avatarURL = avatarURL
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Set root view controller
        if (style == .tabBar) {
            let navigationControllers = items.map { UINavigationController(rootViewController: $0.viewController) }
            tabController = UITabBarController()
            tabController?.setViewControllers(navigationControllers, animated: true)
            for (tag, item) in items.enumerated() {
                item.viewController.tabBarItem = UITabBarItem(title: item.title, image: item.image, tag: tag)
            }
            self.view.addSubview(tabController!.view)
        } else {
            guard let firstVC = items.first?.viewController else { return }
            navigationToolbarController = ATCNavigationToolbarController(rootViewController: firstVC)
            navigationToolbarController?.toolbar.title = items.first?.title
            menuViewController = ATCMenuTableViewController(items: items, avatarURL: avatarURL, nibNameOrNil: "ATCMenuTableViewController", bundle: nil)
            drawerController = ATCNavigationDrawerController(rootViewController: navigationToolbarController!, leftViewController: menuViewController, rightViewController: nil)
            self.view.addSubview(drawerController!.view)
        }
    }
}
