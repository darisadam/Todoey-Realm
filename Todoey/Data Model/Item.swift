//
//  Item.swift
//  Todoey
//
//  Created by Adam Daris Ryadhi on 26/12/24.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  @objc dynamic var dateCreated: Date?
  
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
