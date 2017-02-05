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
        let vc = A1TableViewController(nibName: "A1TableViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
}

