//
//  ViewController2.swift
//  Project_P3_Team_A
//
//  Created by Jacob HInchey on 11/25/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Display the information and photos for a
        // table row with a stack view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden( true, animated: true)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
    }
    

}
