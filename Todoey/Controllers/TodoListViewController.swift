//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Adam Daris Ryadhi on 14/10/24.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
  
  var todoItems: Results<Item>?
  let realm = try! Realm()
  
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
  }
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let item = todoItems?[indexPath.row] {
      
      cell.textLabel?.text = item.title
      
      if let color = selectedCategory?.backgroundColor {
        let darkenedPercentage = CGFloat(indexPath.row) / CGFloat(todoItems!.count)
        let backgroundColor = UIColor(hex: color)?.darkened(by: darkenedPercentage)
        
        cell.backgroundColor = backgroundColor
        cell.textLabel?.textColor = backgroundColor?.contrastTo(backgroundColor!, returnFlat: true)
      }
      
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Items Added"
    }
    
    return cell
  }
  
  //MARK: - TableView Delegates Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error saving done status: \(error)")
      }
    }
    
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK: - Data Manipulation Methods
  
  func loadItems() {
    
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: false)
    
    tableView.reloadData()
  }
  
  override func updateModel(at indexPath: IndexPath) {
    if let itemForDeletion = todoItems?[indexPath.row] {
      do {
        try realm.write {
          realm.delete(itemForDeletion)
        }
      } catch {
        print("Error saving new item: \(error)")
      }
    }
  }
  
  //MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
    
    //Create
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //what will happen if user clicked the Add button
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
          }
        } catch {
          print("Error saving new item: \(error)")
        }
      }
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create New Item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
}

//MARK: - Search Bar Methods

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
