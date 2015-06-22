//
//  Disciplina.swift
//  Organizador
//
//  Created by Rubens Gondek on 6/21/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import CoreData

class Disciplina: NSManagedObject {

    @NSManaged var cor: String
    @NSManaged var media: NSNumber
    @NSManaged var nome: String
    @NSManaged var id: NSNumber
    @NSManaged var atividades: NSSet

}
