//
//  AtividadeManager.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 03/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import CoreData
import UIKit

class AtividadeManager {
    
    static let sharedInstance = AtividadeManager()
    static let entityName: String = "Atividade"
    
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
        
        }()
    
    private init(){}
    
    func novaAtividade() ->Atividade {
        return NSEntityDescription.insertNewObjectForEntityForName(AtividadeManager.entityName, inManagedObjectContext: managedContext) as! Atividade
    }
    
    func buscarAtividades() ->Array<Atividade> {
        let buscaRequest = NSFetchRequest(entityName: AtividadeManager.entityName)
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Atividade] {
            return resultados
        } else {
            println("Não foi possível buscar essa atividade. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Array<Atividade>()
    }
    
    func buscarAtividade(index: Int) -> Atividade{
        var atividade: Atividade = buscarAtividades()[index]
        return atividade
    }
    
    func salvarAtividade() {
        var erro: NSError?
        managedContext.save(&erro)
        
        if let e = erro {
            println("Não foi possível salvar essa atividade. Erro: \(erro), \(erro!.userInfo)")
        }
    }
    
    func removerTodos() {
        var arrayAti: Array<Atividade> = buscarAtividades()
        for atividade: Atividade in arrayAti {
            managedContext.deleteObject(atividade)
        }
    }
    
    func removerAtividade(index: Int) {
        var arrayAti: Array<Atividade> = buscarAtividades()
        managedContext.deleteObject(arrayAti[index] as NSManagedObject)
        salvarAtividade()
    }
    
        func salvarNovaAtividade(nome: String, data: NSDate){
            let atividade = novaAtividade()
    
            atividade.setValue(nome, forKey: "nome")
            atividade.setValue(data, forKey: "data")
            atividade.setValue(0, forKey: "nota")
            salvarAtividade()
        }
    
}
