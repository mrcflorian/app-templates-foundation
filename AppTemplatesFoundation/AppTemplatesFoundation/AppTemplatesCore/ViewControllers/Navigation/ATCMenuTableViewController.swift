//
//  ATCMenuTableViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/10/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

open class ATCMenuTableViewController: UITableViewController {
    fileprivate static let kCellReuseIdentifier = "ATCMenuTableViewCell"

    var items: [ATCNavigationItem]

    init(items: [ATCNavigationItem], nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.items = items
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let cellNib = UINib(nibName: "ATCMenuTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: ATCMenuTableViewController.kCellReuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ATCMenuTableViewController.kCellReuseIdentifier)
        if let cell = cell as? ATCMenuTableViewCell {
            cell.configure(item: items[indexPath.row])
        }

        return cell!
    }

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let tController = toolbarController()
        tController?.toolbar.title = item.title
        tController?.transition(to: item.viewController, completion: closeNavigationDrawer)
    }
}

extension ATCMenuTableViewController {
    fileprivate func closeNavigationDrawer(result: Bool) {
        navigationDrawerController?.closeLeftView()
    }

    fileprivate func toolbarController() -> ATCNavigationToolbarController? {
        return (navigationDrawerController?.rootViewController as? ATCNavigationToolbarController)
    }
}
