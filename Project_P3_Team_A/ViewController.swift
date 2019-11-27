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
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Controls font of Back Button
        backButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Futura", size: 20)!], for: UIControl.State.normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden( true, animated: true)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
    }


}

