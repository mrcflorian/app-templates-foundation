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

public enum ATCNavigationMenuItemType {
    case viewController
    case logout
}

public final class ATCNavigationItem {
    let viewController: UIViewController
    let title: String
    let image: UIImage?
    let type: ATCNavigationMenuItemType

    init(title: String, viewController: UIViewController, image: UIImage?, type: ATCNavigationMenuItemType) {
        self.title = title
        self.viewController = viewController
        self.image = image
        self.type = type
    }
}

open class ATCHostViewController: UIViewController {
    var user: ATCUser? {
        didSet {
            menuViewController?.user = user
            menuViewController?.tableView.reloadData()
        }
    }

    let items: [ATCNavigationItem]
    let style: ATCNavigationStyle
    let topNavigationRightViews: [UIView]
    var topNavigationLeftImage: UIImage?

    open var tabController: UITabBarController?
    open var navigationToolbarController: ATCNavigationController?
    open var menuViewController: ATCMenuTableViewController?
    open var drawerController: ATCNavigationDrawerController?

    init(style: ATCNavigationStyle, items: [ATCNavigationItem], user: ATCUser? = nil, topNavigationRightViews: [UIView] = [UIView](), topNavigationLeftImage: UIImage? = nil) {
        self.style = style
        self.items = items
        self.user = user
        self.topNavigationRightViews = topNavigationRightViews
        self.topNavigationLeftImage = topNavigationLeftImage ?? Icon.cm.menu
        super.init(nibName: nil, bundle: nil)
        configureChildrenViewControllers()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        if (style == .tabBar) {
            self.view.addSubview(tabController!.view)
        } else {
            self.view.addSubview(drawerController!.view)
        }

        UIBarButtonItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName:UIColor.white], for: .normal)
        navigationToolbarController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    fileprivate func configureChildrenViewControllers() {
        if (style == .tabBar) {
            let navigationControllers = items.filter{$0.type == .viewController}.map { UINavigationController(rootViewController: $0.viewController) }
            tabController = UITabBarController()
            tabController?.setViewControllers(navigationControllers, animated: true)
            for (tag, item) in items.enumerated() {
                item.viewController.tabBarItem = UITabBarItem(title: item.title, image: item.image, tag: tag)
            }
        } else {
            guard let firstVC = items.first?.viewController else { return }
            navigationToolbarController = ATCNavigationController(rootViewController: firstVC, topNavigationRightViews: topNavigationRightViews, topNavigationLeftImage: topNavigationLeftImage)
            menuViewController = ATCMenuTableViewController(items: items, user: user, nibNameOrNil: "ATCMenuTableViewController", bundle: nil)
            drawerController = ATCNavigationDrawerController(rootViewController: navigationToolbarController!, leftViewController: menuViewController, rightViewController: nil)
            if let drawerController = drawerController {
                self.addChildViewController(drawerController)
            }
        }
    }
}
