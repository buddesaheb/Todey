//
//  ViewController.swift
//  Todey
//
//  Created by gssdev on 12/18/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    //    Mark: Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    //    Mark: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        saveItem()
        
        
        //        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController.init(title: "Add new Todey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textFeild.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
        do {
            try context.save()
        } catch {
            print("Error while saveing context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        let categoryPedicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPedicate,additionalPredicate])
        }else {
            request.predicate = categoryPedicate
        }
        
        
        do {
            itemArray=try context.fetch(request)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
}
//Mark : Searchbar functionality
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate: predicate)
  }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


