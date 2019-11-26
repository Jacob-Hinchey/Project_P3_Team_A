//
//  LaunchViewController.swift
//  Project_P3_Team_A
//
//  Created by Morgan Houston on 11/26/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden( true, animated: true)
        self.navigationController?.setNavigationBarHidden(true,animated: true)
    }
}
