//
//  ViewController.swift
//  notepad
//
//  Created by Kunwar Luthera on 11/16/18.
//  Copyright © 2018 Kunwar Luthera. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // SELF DEFINED PLIST files where the data will be saved/persisted
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
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
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The Selected row is \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Add Button pressed")
        
        var alertTextFieldData = UITextField()
        
        let alert = UIAlertController(title: "Add New Notepad", message: "Add Notepad", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            let newItem = Item()
            newItem.title = alertTextFieldData.text!
            self.itemArray.append(newItem)
            // USING NSCODER
            self.saveItems()
            print(alertTextFieldData.text!)
            print("SUCCESS AFTER ADD ITEM BUTTON CLICKED")
            
            
        }
        alert.addTextField{ (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text!)
            alertTextFieldData = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        //USING NSCODER INSTEAD OF USER DEFAULTS
        //ENCODER GOES HERE
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("There was an error while encoding \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        // DECODER GOES HERE
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error Decoding data \(error)")
            }
        }
    }
    
}

