//
//  ViewController2.swift
//  Project_P3_Team_A
//
//  Created by Jacob HInchey on 11/25/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    var ID: String = ""
    
    @IBOutlet weak var IDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Display the information and photos for a
        // table row with a stack view
        IDLabel?.text = "ID: \(ID)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden( true, animated: true)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
    }
    

}
