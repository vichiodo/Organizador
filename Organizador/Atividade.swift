//
//  Atividade.swift
//  Organizador
//
//  Created by Ricardo Hochman on 12/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import CoreData

class Atividade: NSManagedObject {

    @NSManaged var data: NSDate
    @NSManaged var nome: String
    @NSManaged var nota: NSNumber
    @NSManaged var peso: NSNumber
    @NSManaged var tipo: NSNumber
    @NSManaged var valeNota: NSNumber
    @NSManaged var concluido: NSNumber
    @NSManaged var obs: String
    @NSManaged var disciplina: Disciplina
    @NSManaged var id: NSNumber

}
