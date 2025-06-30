//
//  Category.swift
//  Todoey
//
//  Created by Adam Daris Ryadhi on 26/12/24.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var backgroundColor: String = ""
  
  let items = List<Item>()
}
