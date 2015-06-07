//
//  ProvaManager.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 03/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import CoreData
import UIKit

class ProvaManager {
    
    static let sharedInstance = ProvaManager()
    static let entityName: String = "Prova"
    
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
        
        }()
    
    private init(){}
    
    func novaProva() ->Prova {
        return NSEntityDescription.insertNewObjectForEntityForName(ProvaManager.entityName, inManagedObjectContext: managedContext) as! Prova
    }
    
    func buscarProvas() ->Array<Prova> {
        let buscaRequest = NSFetchRequest(entityName: ProvaManager.entityName)
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Prova] {
            return resultados
        } else {
            println("Não foi possível buscar essa prova. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Array<Prova>()
    }
    
    func buscarProva(index: Int) -> Prova{
        var prova: Prova = buscarProvas()[index]
        return prova
    }
    
    func salvarProva() {
        var erro: NSError?
        managedContext.save(&erro)
        
        if let e = erro {
            println("Não foi possível salvar essa prova. Erro: \(erro), \(erro!.userInfo)")
        }
    }
    
    func removerTodos() {
        var arrayProva: Array<Prova> = buscarProvas()
        for prova: Prova in arrayProva {
            managedContext.deleteObject(prova)
        }
    }
    
    func removerProva(index: Int) {
        var arrayProva: Array<Prova> = buscarProvas()
        managedContext.deleteObject(arrayProva[index] as NSManagedObject)
        salvarProva()
    }
    
    func salvarNovaProva(nome: String, data: NSDate, materia: Disciplina){
        let prova = novaProva()
        
        prova.setValue(nome, forKey: "nome")
        prova.setValue(data, forKey: "data")
        prova.setValue(0, forKey: "nota")
        prova.setValue(materia, forKey: "disciplina")
        salvarProva()
    }
    
}
