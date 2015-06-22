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
    
    func buscarDisciplina(id: Int) -> Disciplina {
        let buscaRequest = NSFetchRequest(entityName: DisciplinaManager.entityName)
        buscaRequest.predicate = NSPredicate(format: "id == %i", id)
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Disciplina] {
            return resultados.last!
        } else {
            println("Não foi possível buscar essa Disciplina. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Disciplina()
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
    
    func removerDisciplina(id: Int) {
        var disciplina: Disciplina = buscarDisciplina(id)
        managedContext.deleteObject(disciplina as NSManagedObject)
        salvarDisciplina()
    }
    
    func salvarNovaDisciplina(nome: String, cor: String){
        
        var idAtual: Int!
        var array = buscarDisciplinas()
        if array.isEmpty {
            idAtual = 0
        } else {
            var obj = array.last! as Disciplina
            idAtual = Int(obj.id) + 1
        }
        
        let disciplina = novaDisciplina()
        
        disciplina.setValue(idAtual, forKey: "id")
        
        disciplina.setValue(nome, forKey: "nome")
        disciplina.setValue(0, forKey: "media")
        disciplina.setValue(cor, forKey: "cor")
        
        salvarDisciplina()
    }
    
    func salvarDisciplinaCloud(nome: String, cor: String, media: Double, id: Int){
        let disciplina = novaDisciplina()
        
        disciplina.setValue(id, forKey: "id")
        
        disciplina.setValue(nome, forKey: "nome")
        disciplina.setValue(media, forKey: "media")
        disciplina.setValue(cor, forKey: "cor")
        
        salvarDisciplina()
    }

    
}