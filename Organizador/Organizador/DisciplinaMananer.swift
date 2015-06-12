//
//  DisciplinaMananer.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 06/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import CoreData
import UIKit

class DisciplinaManager {
    
    static let sharedInstance = DisciplinaManager()
    static let entityName: String = "Disciplina"
    
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
        
        }()
    
    private init(){}
    
    func novaDisciplina() ->Disciplina {
        return NSEntityDescription.insertNewObjectForEntityForName(DisciplinaManager.entityName, inManagedObjectContext: managedContext) as! Disciplina
    }
    
    func buscarDisciplinas() ->Array<Disciplina> {
        let buscaRequest = NSFetchRequest(entityName: DisciplinaManager.entityName)
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Disciplina] {
            return resultados
        } else {
            println("Não foi possível buscar essa disciplina. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Array<Disciplina>()
    }
    
    func buscarDisciplina(index: Int) -> Disciplina {
        var disciplina: Disciplina = buscarDisciplinas()[index]
        return disciplina
    }
    
    func salvarDisciplina() {
        var erro: NSError?
        managedContext.save(&erro)
        
        if let e = erro {
            println("Não foi possível salvar essa disciplina. Erro: \(erro), \(erro!.userInfo)")
        }
    }
    
    func removerTodos() {
        var arrayDisci: Array<Disciplina> = buscarDisciplinas()
        for disciplina: Disciplina in arrayDisci {
            managedContext.deleteObject(disciplina)
        }
    }
    
    func removerDisciplina(index: Int) {
        var arrayDisci: Array<Disciplina> = buscarDisciplinas()
        managedContext.deleteObject(arrayDisci[index] as NSManagedObject)
        salvarDisciplina()
    }
    
    func salvarNovaDisciplina(nome: String, cor: String){
        let disciplina = novaDisciplina()
        
        disciplina.setValue(nome, forKey: "nome")
        disciplina.setValue(0, forKey: "media")
        disciplina.setValue(cor, forKey: "cor")
        
        salvarDisciplina()
    }
    
}