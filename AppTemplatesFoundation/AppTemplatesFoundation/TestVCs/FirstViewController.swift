//
//  FirstViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/8/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func didSexMe(_ sender: UIButton) {
        let vc = UIViewController()
        vc.title = "SEX"
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
