//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lind Ucdcd on 5/17/19.
//  Copyright © 2019 Lind Ucdcd. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
    }

   
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category ", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Success")

            let newCategory = Category()
            newCategory.name = textField.text!

          self.save(category: newCategory)

        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAtIndexPath Called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    
    //MARK: - Data Manipulation methods
    
    func save(category: Category) {
        
        do {
            
            try realm.write {
                
                realm.add(category)
                }
        } catch {
            
            print("context have Error: \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
     categories = realm.objects(Category.self)
        
        
    }
    
    
    
}
