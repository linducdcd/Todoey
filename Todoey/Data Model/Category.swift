//
//  Category.swift
//  Todoey
//
//  Created by Lind Ucdcd on 5/18/19.
//  Copyright © 2019 Lind Ucdcd. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
    
}
