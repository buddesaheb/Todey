//
//  ViewController.swift
//  Todey
//
//  Created by gssdev on 12/18/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Bring Milk"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destory Demogonous"
        itemArray.append(newItem3)
        
                if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
                    itemArray = items
                }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    //    Mark: Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//        This above experision is converted like Ternary operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    //    Mark: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController.init(title: "Add new Todey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textFeild.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            
            
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Creat new item"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
}

