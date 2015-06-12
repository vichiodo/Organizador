//
//  Disciplina.swift
//  Organizador
//
//  Created by Ricardo Hochman on 12/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import CoreData

class Disciplina: NSManagedObject {

    @NSManaged var media: NSNumber
    @NSManaged var nome: String
    @NSManaged var cor: String
    @NSManaged var atividades: Atividade

}
