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
    
    func buscarProvas() -> Array<Atividade> {
        let buscaRequest = NSFetchRequest(entityName: AtividadeManager.entityName)
        buscaRequest.predicate = NSPredicate(format: "tipo == %i", 0)
//        buscaRequest.sortDescriptors = [NSSortDescriptor(key: "data", ascending: false)]
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Atividade] {
            return resultados
        } else {
            println("Não foi possível buscar essa atividade. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
//        var results: [Atividade] = []
        
//        var sortedResults = sorted(results, {
//            $0.data.compare($1.data) == NSComparisonResult.OrderedDescending
//        })
        

        return Array<Atividade>()
    }
    
    func buscarTarefas() -> Array<Atividade> {
        let buscaRequest = NSFetchRequest(entityName: AtividadeManager.entityName)
        buscaRequest.predicate = NSPredicate(format: "tipo == %i", 1)
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
    
    func buscarAtividades() -> Array<Atividade> {
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

    func buscarAtividadesConcluidas() -> Array<Atividade> {
        let buscaRequest = NSFetchRequest(entityName: AtividadeManager.entityName)
        buscaRequest.predicate = NSPredicate(format: "concluido == %i", 1)
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

    
    func buscarAtividadesNaoConcluidas() -> Array<Atividade> {
        let buscaRequest = NSFetchRequest(entityName: AtividadeManager.entityName)
        buscaRequest.predicate = NSPredicate(format: "concluido == %i", 0)
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
    
    func buscarAtividade(id: Int) -> Atividade {
        let buscaRequest = NSFetchRequest(entityName: AtividadeManager.entityName)
        buscaRequest.predicate = NSPredicate(format: "id == %i", id)
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Atividade] {
            return resultados.last!
        } else {
            println("Não foi possível buscar essa atividade. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Atividade()
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
    
    func removerProva(id: Int) {
        var arrayAti: Array<Atividade> = buscarProvas()
        managedContext.deleteObject(arrayAti[id] as NSManagedObject)
        salvarAtividade()
    }
    
    func removerTarefa(id: Int) {
        var arrayAti: Array<Atividade> = buscarTarefas()
        managedContext.deleteObject(arrayAti[id] as NSManagedObject)
        salvarAtividade()
    }

    func salvarNovaAtividade(nome: String, data: NSDate, materia: Disciplina, peso: Int, tipo: Int, valeNota: Bool, obs: String){
        var idAtual: Int!
        var array = buscarAtividades()
        if array.isEmpty {
            idAtual = 0
        }else {
            var obj = array.last! as Atividade
            idAtual = Int(obj.id) + 1
        }
        
        
        let atividade = novaAtividade()
        
        
        atividade.setValue(idAtual, forKey: "id")
        
        atividade.setValue(nome, forKey: "nome")
        atividade.setValue(data, forKey: "data")
        atividade.setValue(0, forKey: "nota")
        atividade.setValue(peso, forKey: "peso")
        atividade.setValue(tipo, forKey: "tipo")
        atividade.setValue(valeNota, forKey: "valeNota")
        atividade.setValue(obs, forKey: "obs")
        atividade.setValue(materia, forKey: "disciplina")
        atividade.setValue(0, forKey: "concluido")
        
        
        
        
        salvarAtividade()
    }
    
}
