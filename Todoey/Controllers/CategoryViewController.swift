//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adam Daris Ryadhi on 22/10/24.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
  
  let realm = try! Realm()
  
  var categories: Results<Category>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controlloer not exist") }
    
    navBar.backgroundColor = UIColor(hex: "1D9BF6")
  }
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let category = categories?[indexPath.row] {
      cell.textLabel?.text = category.name
      
      if let categoryColor = UIColor(hex: category.backgroundColor) {
        cell.textLabel?.textColor = categoryColor.contrastTo(categoryColor, returnFlat: true)
        cell.backgroundColor = categoryColor
      }
    }
    
    return cell
  }
  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
  }
  
  //MARK: - Data Manipulation Methods
  
  func save(category: Category) {
    
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving new category: \(error)")
    }
    
    tableView.reloadData()
  }
  
  func loadCategories() {
    
    categories = realm.objects(Category.self)
    
    tableView.reloadData()
  }
  
  //MARK: - Delete Data From Swipe
  
  override func updateModel(at indexPath: IndexPath) {
    if let categoryForDeletion = categories?[indexPath.row] {
      do {
        try realm.write {
          realm.delete(categoryForDeletion)
        }
      } catch {
        print("Error saving new category: \(error)")
      }
    }
  }
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Category", message: nil, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      
      let newCategory = Category()
      newCategory.name = textField.text!
      newCategory.backgroundColor = UIColor.randomColor().toHex()
      
      self.save(category: newCategory)
    }
    
    alert.addTextField() { (alertTextField) in
      alertTextField.placeholder = "Create New Category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
}
