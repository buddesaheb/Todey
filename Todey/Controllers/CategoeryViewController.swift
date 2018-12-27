//
//  CategoeryViewController.swift
//  Todey
//
//  Created by gssdev on 12/26/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import CoreData

class CategoeryViewController: UITableViewController {
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

      
    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController.init(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context : self .context)
            newCategory.name = textFeild.text!
            self.categoryArray.append(newCategory)
            self.saveItem()
            
            
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Create new Category"
            textFeild = alertTextFeild
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    //Mark: - TableView DataSorce methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for : indexPath)
        
        let cateogry = categoryArray[indexPath.row]
        cell.textLabel?.text = cateogry.name
        
        return cell
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("Category saving \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    
}
