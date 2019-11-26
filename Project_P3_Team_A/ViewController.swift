//
//  ViewController.swift
//  Project_P3_Team_A
//
//  Created by Jacob HInchey on 10/22/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //after long tap we segue here
    //we need to add functionality to edit the train data
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden( true, animated: true)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
    }


}

