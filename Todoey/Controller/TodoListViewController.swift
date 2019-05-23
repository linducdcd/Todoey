//
//  ViewController.swift
//  Todoey
//
//  Created by Lind Ucdcd on 5/14/19.
//  Copyright © 2019 Lind Ucdcd. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
      
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let coulorHex = selectedCategory?.colour {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
            navBar.barTintColor = UIColor(hexString: coulorHex)
            
            searchBar.barTintColor = UIColor(hexString: coulorHex)
        }
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAtIndexPath Called")
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = "\(String(indexPath.row + 1))- " + (item.title)
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                    print("Error saving done ststus, \(error)")
                }
            }
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            
            if let currebtCategory = self.selectedCategory {
                do {
                try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currebtCategory.items.append(newItem)
                }
                }catch {
                    print("Error saving new Items, \(error)")
                }
            }
            self.tableView.reloadData()
           }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
  
    
    func loadItems() {
        
      todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        

        tableView.reloadData()
        tableView.rowHeight = 60.0
    }

   
        
    // delete data from swipe method
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemsForDeletion = todoItems?[indexPath.row] {
            
            do {
                
                try self.realm.write {
                    
                    self.realm.delete(itemsForDeletion)
                }
            } catch {
                
                print("deliting Error: \(error)")
                
            }
            
        }
    }
        
    }


//MARK: - serachBar Methods

    extension TodoListViewController: UISearchBarDelegate {

         func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
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

