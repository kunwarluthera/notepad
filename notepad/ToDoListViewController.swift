//
//  ViewController.swift
//  notepad
//
//  Created by Kunwar Luthera on 11/16/18.
//  Copyright © 2018 Kunwar Luthera. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["KunwarNotepad","AnuNotepad","MishuNotepad"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("No of rows in selection \(itemArray.count)")
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Calling cell for row at ")
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The Selected row is \(itemArray[indexPath.row])")
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Add Button pressed")
        
        var alertTextFieldData = UITextField()
        
        let alert = UIAlertController(title: "Add New Notepad", message: "Add Notepad", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            self.itemArray.append(alertTextFieldData.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            print(alertTextFieldData.text!)
            print("SUCCESS AFTER ADD ITEM BUTTON CLICKED")
            self.tableView.reloadData()
            
        }
        alert.addTextField{ (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text!)
            alertTextFieldData = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

