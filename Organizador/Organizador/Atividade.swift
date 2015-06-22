//
//  Atividade.swift
//  Organizador
//
//  Created by Rubens Gondek on 6/21/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import CoreData

class Atividade: NSManagedObject {

    @NSManaged var concluido: NSNumber
    @NSManaged var data: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var nome: String
    @NSManaged var nota: NSNumber
    @NSManaged var obs: String
    @NSManaged var peso: NSNumber
    @NSManaged var tipo: NSNumber
    @NSManaged var valeNota: NSNumber
    @NSManaged var disciplina: Disciplina

}
