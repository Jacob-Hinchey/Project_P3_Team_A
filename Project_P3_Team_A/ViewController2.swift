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
    var serviceType: String = ""
    var aarType: String = ""
    var roadNum: String = ""
    var material: String = ""
    var length: String = ""
    var color: String = ""
    var axles: String = ""
    var retailerName: String = ""
    
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var aarLabel: UILabel!
    @IBOutlet weak var roadLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var axilLabel: UILabel!
    @IBOutlet weak var retailerLabel: UILabel!
    @IBOutlet weak var trainImage1: UIImageView!
    @IBOutlet weak var trainImage2: UIImageView!
    @IBOutlet weak var trainImage3: UIImageView!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Display the information and photos for a
        // table row with a stack view
        IDLabel?.text = "ID: \(ID)"
        serviceLabel?.text = "Service Type: \(serviceType)"
        aarLabel?.text = "AAR Type: \(aarType)"
        roadLabel?.text = "Road Number: \(roadNum)"
        materialLabel?.text = "Material: \(material)"
        lengthLabel?.text = "Length: \(length)"
        colorLabel?.text = "Color: \(color)"
        axilLabel?.text = "Wheels & Axils: \(axles)"
        retailerLabel?.text = "Retailer Name: \(retailerName)"
        
        // Controls Font of Back Button
        backButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Futura", size: 20)!], for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden( true, animated: true)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
    }
    

}
