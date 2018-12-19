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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
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
        saveItem()
        
        
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
            self.saveItem()
            
            
            
            
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Creat new item"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    func saveItem(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array!")
        }
        
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try?  Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
        }
        
    }
}

