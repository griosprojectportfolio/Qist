//
//  Store.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import CoreData

class Store: NSManagedObject {

    @NSManaged var store_id: NSNumber
    @NSManaged var store_name: String
    @NSManaged var store_title: String
    @NSManaged var store_imgUrl: String
    
}
