//
//  Disciplina.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 03/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import CoreData

class Disciplina: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var media: NSNumber
    @NSManaged var atividade: NSSet
    @NSManaged var prova: NSSet

}
