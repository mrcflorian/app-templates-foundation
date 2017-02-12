//
//  ATCMenuTableViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/10/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Material
import UIKit

open class ATCMenuTableViewController: UITableViewController {
    fileprivate static let kCellReuseIdentifier = "ATCMenuTableViewCell"

    fileprivate var lastSelectedIndexPath: IndexPath?

    var items: [ATCNavigationItem]
    var user: ATCUser?

    init(items: [ATCNavigationItem], user: ATCUser?, nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.items = items
        self.user = user
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let cellNib = UINib(nibName: "ATCMenuTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: ATCMenuTableViewController.kCellReuseIdentifier)

        let headerNib = UINib(nibName: "ATCMenuHeaderTableViewCell", bundle:nil)
        tableView.register(headerNib, forCellReuseIdentifier: "ATCMenuHeaderTableViewCell")

        lastSelectedIndexPath = IndexPath(row: 0, section: 0)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(colorLiteralRed: 39/255, green: 44/255, blue: 48/255, alpha: 1)
        tableView.backgroundView = backgroundView
        tableView.separatorColor = Color.grey.darken1
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
        if (lastSelectedIndexPath == indexPath) {
            closeNavigationDrawer(result: true)
            return
        }
        let item = items[indexPath.row]
        let dController = drawerController()
        let navigationController = ATCNavigationController(rootViewController: item.viewController)
        dController?.transition(to: navigationController, completion: closeNavigationDrawer)
        lastSelectedIndexPath = indexPath
    }

    override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ATCMenuHeaderTableViewCell") as? ATCMenuHeaderTableViewCell
        cell?.configureCell(user: user)
        return cell
    }

    override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}

extension ATCMenuTableViewController {
    fileprivate func closeNavigationDrawer(result: Bool) {
        navigationDrawerController?.closeLeftView()
    }

    fileprivate func drawerController() -> ATCNavigationDrawerController? {
        return (navigationDrawerController?.rootViewController.parent as? ATCNavigationDrawerController)
    }
}
