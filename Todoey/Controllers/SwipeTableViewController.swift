//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Adam Daris Ryadhi on 30/06/25.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = 50
  }
  
  //TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      
      self.updateModel(at: indexPath)
    }
    
    deleteAction.image = UIImage(systemName: "trash")
    
    return [deleteAction]
  }
  
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    return options
  }
  
  func updateModel(at indexPath: IndexPath) {
    
  }
}
