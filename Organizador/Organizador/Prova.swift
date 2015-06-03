//
//  Prova.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 03/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import CoreData

class Prova: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var nota: NSNumber
    @NSManaged var data: NSDate

}
