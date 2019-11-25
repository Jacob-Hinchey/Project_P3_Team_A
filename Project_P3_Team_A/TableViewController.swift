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


class TableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //get the csv file and parse it
        guard let csvPath = Bundle.main.path(forResource: "CURR_EQUIP", ofType: "csv") else { return }
        
        do {
            let csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
            let csv = csvData.csvRows()
            
            for row in csv {
                print(row)
            }
        } catch{
            print(error)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch the database contents.
        
    
    }
    
    
    //For long press on table cell
    @IBAction func editTrain(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            //seque to view controller
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "My Cell", for: indexPath)
        
        // Configure the cell...
        // Display the cell label and subtitle.
        
        return cell
    }
    
}


//parsing algorithm
extension String {
    func csvRows() -> [[String]] {
        var rows : [[String]] = []
        
        let newlineCharacterSet = CharacterSet.newlines
        let importantCharactersSet = CharacterSet(charactersIn: ",\"").union(newlineCharacterSet)
        
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            var insideQuotes = false
            var finishedRow = false
            var columns : [String] = []
            var currentColumn = ""
            while !finishedRow {
                var tempString : NSString? = nil
                if scanner.scanUpToCharacters(from: importantCharactersSet, into: &tempString) {
                    currentColumn.append(tempString! as String)
                }
                
                if scanner.isAtEnd {
                    if currentColumn != "" {
                        columns.append(currentColumn)
                    }
                    finishedRow = true
                } else if scanner.scanCharacters(from: newlineCharacterSet, into: &tempString) {
                    if insideQuotes {
                        // Add line break to column text
                        currentColumn.append(tempString! as String)
                    } else {
                        // End of row
                        if currentColumn != "" {
                            columns.append(currentColumn)
                        }
                        finishedRow = true
                    }
                } else if scanner.scanString("\"", into: nil) {
                    if insideQuotes && scanner.scanString("\"", into: nil) {
                        // Replace double quotes with a single quote in the column string.
                        currentColumn.append("\"")
                    } else {
                        // Start or end of a quoted string.
                        insideQuotes = !insideQuotes
                    }
                } else if scanner.scanString(",", into: nil) {
                    if insideQuotes {
                        currentColumn.append(",")
                    } else {
                        // This is a column separating comma
                        columns.append(currentColumn)
                        currentColumn = ""
                        scanner.scanCharacters(from: CharacterSet.whitespaces, into: nil)
                    }
                }
            }
            if columns.count > 0 {
                rows.append(columns)
            }
        }
        return rows
    }
}
