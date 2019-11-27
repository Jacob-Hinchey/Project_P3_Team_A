//
//  TableViewController.swift
//  Project_P3_Team_A
//
//  Created by Morgan Houston on 11/12/19.
//  Copyright © 2019 Team A. All rights reserved.
//

// short tap will display() the train data
// need to add filter() functionality
// need to add refresh() functionality
// long tap will segue to ViewController which will allow editing the data
import Foundation
import UIKit
import CoreData

// Created a custom class that adds a dictionary to the UITableViewCell so we can save all information to an individual cell
class NewTableViewCell : UITableViewCell{
    var cellData : [String : String] = [:]
}

class TableViewController: UITableViewController {
    var tableCells = [[]]
    let headers = ["List of Trains"]
    var valueToPass : [String : String] = [:]
    var trainData : [[String : String]] = [[:]]
    
    
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Changes font of toolbar button
        filterButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Futura", size: 20)!], for: UIControl.State.normal)


        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //get the csv file and parse it
        guard let csvPath = Bundle.main.path(forResource: "CURR_EQUIP", ofType: "csv") else { return }
        
        do {
            let csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
            trainData = CSwiftV(with: csvData).keyedRows!
            
        } catch{
            print(error)
        }
        
        tableCells[0] = trainData
    }
    
    // Hide toolbar and show navBar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden( true, animated: true)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
    }
    
    // send cell data to VC2 through the segue using data from each cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showSegue"
        {
            if segue.destination is ViewController2
            {
                let vc2 = segue.destination as? ViewController2
                vc2?.ID = valueToPass["Auto number ID"]!
                vc2?.serviceType = valueToPass["Service Type"]!
                vc2?.aarType = valueToPass["AAR Type"]!
                vc2?.roadNum = valueToPass["Road number"]!
                vc2?.material = valueToPass["Construction material"]!
                vc2?.length = valueToPass["Length-whole numbers"]!
                vc2?.color = valueToPass["Color"] ?? ""
                vc2?.axles = valueToPass["Wheels and axles"] ?? ""
                
                vc2?.retailerName = valueToPass["Retailers Name"]!
                if (valueToPass["Picture file name 2"] != nil){
                    vc2?.image1 = valueToPass["Picture file name 2"]!
                }
                if (valueToPass["Picture file name 3"] != nil){
                    vc2?.image2 = valueToPass["Picture file name 3"]!
                }
                if (valueToPass["Picture file name 4"] != nil){
                    vc2?.image3 = valueToPass["Picture file name 4"]!
                }
            }
        }
    }
    
    // Set the total number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the total number of rows per section, based on the number or cells in tableCells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableCells[section].count
    }
    
    // TODO: Make this work
    @IBAction func editTrain(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            performSegue(withIdentifier: "editSegue", sender: self)
        }
    }
    
    // segue in show information viewcontroller
    // on short press with deselect (information not being passed yet)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! NewTableViewCell
        
        //Deselect the cell after the path is grabbed
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Set the data to send to the segue with the cell data from selected cell
        valueToPass = currentCell.cellData
        performSegue(withIdentifier: "showSegue", sender: self)
    }
    
    //Overrides system font for header
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "Futura", size: 25)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
    }
    
    // show data in cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> NewTableViewCell {
        // Cast the cell as a NewTableViewCell to use the cellData values
        let cell = tableView.dequeueReusableCell(withIdentifier: "My Cell", for: indexPath) as! NewTableViewCell
        cell.cellData = trainData[indexPath.row] // Add cellData
        
        // Controls cell fonts
        cell.textLabel?.font = (UIFont(name: "Futura", size: 20))
        
        // Set the labels to the road number and service type
        if indexPath.section == 0 {
            // This helps the formatting look beter, if you dont scroll down
            cell.textLabel?.text = String(format: "%@:  \t\t\t%@    \t %@",cell.cellData["Auto number ID"]!, cell.cellData["Road number"]!, cell.cellData["Service Type"]!)
            

        }
        
        // Alternate colors as per the client's request
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.black
            cell.textLabel!.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.orange
            cell.textLabel!.textColor = UIColor.black
        }
        
        return cell
    }
    
    // Set the headers
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headers.count {
            return headers[section]
        }
        
        return nil
    }
}

/* THIS IS A MUCH BETTER PARSING CLASS I FOUND WE CAN USE */
extension String {
    
    var isEmptyOrWhitespace: Bool {
        return isEmpty || trimmingCharacters(in: .whitespaces) == ""
    }
    
    var isNotEmptyOrWhitespace: Bool {
        return !isEmptyOrWhitespace
    }
}

// MARK: Parser
public class CSwiftV {
    /// The number of columns in the data
    private let columnCount: Int
    /// The headers from the data, an Array of String
    public let headers: [String]
    /// An array of Dictionaries with the values of each row keyed to the header
    public let keyedRows: [[String: String]]?
    /// An Array of the rows in an Array of String form, equivalent to keyedRows, but without the keys
    public let rows: [[String]]
    
    /// Creates an instance containing the data extracted from the `with` String
    /// - Parameter with: The String obtained from reading the csv file.
    /// - Parameter separator: The separator used in the csv file, defaults to ","
    /// - Parameter headers: The array of headers from the file. If not included, it will be populated with the ones from the first line
    public init(with string: String, separator: String = ",", headers: [String]? = nil) {
        var parsedLines = CSwiftV.records(from: string.replacingOccurrences(of: "\r\n", with: "\n")).map { CSwiftV.cells(forRow: $0, separator: separator) }
        self.headers = headers ?? parsedLines.removeFirst()
        rows = parsedLines
        columnCount = self.headers.count
        
        let tempHeaders = self.headers
        keyedRows = rows.map { field -> [String: String] in
            var row = [String: String]()
            // Only store value which are not empty
            for (index, value) in field.enumerated() where value.isNotEmptyOrWhitespace {
                if index < tempHeaders.count {
                    row[tempHeaders[index]] = value
                }
            }
            return row
        }
    }
    
    /// Creates an instance containing the data extracted from the `with` String
    /// - Parameter with: The string obtained from reading the csv file.
    /// - Parameter headers: The array of headers from the file. I f not included, it will be populated with the ones from the first line
    /// - Attention: In this conveniennce initializer, we assume that the separator between fields is ","
    public convenience init(with string: String, headers: [String]?) {
        self.init(with: string, separator:",", headers:headers)
    }
    
    /// Analizes a row and tries to obtain the different cells contained as an Array of String
    /// - Parameter forRow: The string corresponding to a row of the data matrix
    /// - Parameter separator: The string that delimites the cells or fields inside the row. Defaults to ","
    internal static func cells(forRow string: String, separator: String = ",") -> [String] {
        return CSwiftV.split(separator, string: string)
    }
    
    /// Analizes the CSV data as an String, and separates the different rows as an individual String each.
    /// - Parameter forRow: The string corresponding the whole data
    /// - Attention: Assumes "\n" as row delimiter, needs to filter string for "\r\n" first
    internal static func records(from string: String) -> [String] {
        return CSwiftV.split("\n", string: string).filter { $0.isNotEmptyOrWhitespace }
    }
    
    /// Tries to preserve the parity between open and close characters for different formats. Analizes the escape character count to do so
    private static func split(_ separator: String, string: String) -> [String] {
        func oddNumberOfQuotes(_ string: String) -> Bool {
            return string.components(separatedBy: "\"").count % 2 == 0
        }
        
        let initial = string.components(separatedBy: separator)
        var merged = [String]()
        for newString in initial {
            guard let record = merged.last , oddNumberOfQuotes(record) == true else {
                merged.append(newString)
                continue
            }
            merged.removeLast()
            let lastElem = record + separator + newString
            merged.append(lastElem)
        }
        return merged
    }
}
