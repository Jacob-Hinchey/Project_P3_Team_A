//
//  TableViewController.swift
//  Project_P3_Team_A
//
//  Created by Morgan Houston on 11/12/19.
//  Copyright © 2019 Team A. All rights reserved.
//


//TESTING
// short tap will display() the train data
// need to add filter() functionality
// need to add refresh() functionality
// long tap will segue to ViewController which will allow editing the data
import Foundation
import UIKit
import CoreData


class TableViewController: UITableViewController {
    public var roadNumbers: [String] = []
    var autoNumbers: [String] = []
    var tableCells = [[]]
    let headers = ["Trains"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the csv file and parse it
        guard let csvPath = Bundle.main.path(forResource: "CURR_EQUIP", ofType: "csv") else { return }
        
        do {
            let csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
            let arrayHeaderRowCombined : [[String : String]] = CSwiftV(with: csvData).keyedRows!
            
            for row in arrayHeaderRowCombined {
                autoNumbers.append(row["Auto number ID"]!)
                roadNumbers.append(row["Road number"]!)
            }
        } catch{
            print(error)
        }
        
        tableCells[0] = autoNumbers
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableCells[section].count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch the database contents.
    }
    
    
    @IBAction func editTrain(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            //long press segue
        }
    }
    
    // segue in show information viewcontroller
    // on short press with deselect (information not being passed yet)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "My Cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = String(format: "%@ - %@", autoNumbers[indexPath.row], roadNumbers[indexPath.row])
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.black
            cell.textLabel!.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.orange
            cell.textLabel!.textColor = UIColor.black
        }
        
        // Configure the cell...
        // Display the cell label and subtitle.
        
        return cell
    }
    
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
