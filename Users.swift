//
//  Users.swift
//  swiftPeaceTrack<3
//
//  Created by Shelagh McGowan on 8/13/14.
//  Copyright (c) 2014 Shelagh McGowan. All rights reserved.
//

import Foundation
import CoreData

class Users: NSManagedObject {

    @NSManaged var password: String
    @NSManaged var post: String
    @NSManaged var sector: String
    @NSManaged var username: String

}
