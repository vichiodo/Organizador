//
//  CloudKitHelper.swift
//  Organizador
//
//  Created by Rubens Gondek on 6/21/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitHelper {
    static let shared = CloudKitHelper()
    
    let container = CKContainer.defaultContainer()
    let privateDB: CKDatabase!
    
    let userDef = NSUserDefaults.standardUserDefaults()
    
    lazy var disciplinas:Array<Disciplina> = {
        return DisciplinaManager.sharedInstance.buscarDisciplinas()
        }()
    
    lazy var atividades:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarAtividades()
        }()
    
    init() { privateDB = container.privateCloudDatabase }
    
    func CoreDataModificado() {
        println("EIIITA, Mudou o CoreData")
        userDef.setValue(NSDate(), forKey: "CDLastUpdate")
        userDef.synchronize()
        AtualizaCloud()
    }
    
    func LastUpdateCoreData() -> NSDate {
        return userDef.valueForKey("CDLastUpdate") as! NSDate
    }
    
    func Update() {
        let query = CKQuery(recordType: "Atividade", predicate: NSPredicate(value: true))
        privateDB.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                if results.count > 0 {
                    var record: CKRecord = results.last as! CKRecord
                    var dateCloud = record.modificationDate
                    
                    println(self.LastUpdateCoreData().timeIntervalSinceDate(dateCloud))
                    
                    if self.LastUpdateCoreData().timeIntervalSinceDate(dateCloud) < 0 {
                        self.AtualizaCoreData()
                    }
                }
            }
        })
    }
    
    @objc func AtualizaCloud() {
        CloudDisciplinas()
        CloudAtividades()
    }
    
    func AtualizaCoreData() {
        CoreDataDisciplinas()
        CoreDataAtividades()
        CoreDataModificado()
    }
    
    func CloudDisciplinas() {
        println("iCloud")
        
        // Salva novos e atualiza registros existentes
        let query = CKQuery(recordType: "Disciplina", predicate: NSPredicate(value: true))
        var records: [CKRecord] = []
        
        privateDB.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                for result in results {
                    records.append(result as! CKRecord)
                }
            }
            var tem: Bool!
            var record: CKRecord!
            
            for d in self.disciplinas {
                tem = false
                for r in records {
                    if r.valueForKey("id") as! NSNumber == d.id {
                        tem = true
                        record = r
                        println("Update d")
                    }
                }
                
                if !tem {
                    record = CKRecord(recordType: "Disciplina")
                    record.setObject(d.id, forKey: "id")
                    println("nova materia")
                }
                
                record.setObject(d.nome, forKey: "nome")
                record.setObject(d.cor, forKey: "cor")
                record.setObject(d.media, forKey: "media")
                
                self.privateDB.saveRecord(record, completionHandler: { (rec, error) -> Void in
                    if error != nil {
                        println(error)
                    }
                    
                    println("Materia \(d.nome) Salva")
                })
            }
            
            // Exclui registros não existentes
            for record in records {
                tem = false
                for disc in self.disciplinas {
                    if record.valueForKey("id") as! NSNumber == disc.id {
                        tem = true
                    }
                }
                if !tem {
                    self.privateDB.deleteRecordWithID(record.recordID, completionHandler: nil)
                }
            }
        })
    }
    
    func CloudAtividades() {
        println("iCloud")
        
        // Salva novos e atualiza registros existentes
        let query = CKQuery(recordType: "Atividade", predicate: NSPredicate(value: true))
        var records: [CKRecord] = []
        
        privateDB.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                for result in results {
                    records.append(result as! CKRecord)
                }
            }
            var tem: Bool!
            var record: CKRecord!
            
            for a in self.atividades {
                tem = false
                for r in records {
                    if r.valueForKey("id") as! NSNumber == a.id {
                        tem = true
                        record = r
                        println("Update a")
                    }
                }
                
                if !tem {
                    record = CKRecord(recordType: "Atividade")
                    record.setObject(a.id, forKey: "id")
                    println("nova atividade")
                }
                
                record.setObject(a.concluido, forKey: "concluido")
                record.setObject(a.data, forKey: "data")
                record.setObject(a.disciplina.id, forKey: "disciplina")
                record.setObject(a.nome, forKey: "nome")
                record.setObject(a.nota, forKey: "nota")
                record.setObject(a.obs, forKey: "obs")
                record.setObject(a.peso, forKey: "peso")
                record.setObject(a.tipo, forKey: "tipo")
                record.setObject(a.valeNota, forKey: "valeNota")
                
                self.privateDB.saveRecord(record, completionHandler: { (rec, error) -> Void in
                    if error != nil {
                        println(error)
                    }
                    
                    println("Atividade \(a.nome) Salva")
                })
            }
            
            // Exclui registros não existentes
            for r in records {
                tem = false
                for a in self.atividades {
                    if r.valueForKey("id") as! NSNumber == a.id {
                        tem = true
                    }
                }
                if !tem {
                    self.privateDB.deleteRecordWithID(r.recordID, completionHandler: nil)
                }
            }
        })
    }
    
    func CoreDataDisciplinas() {
        
        // Salva novos e atualiza registros existentes
        println("CoreData")
        
        let query = CKQuery(recordType: "Disciplina", predicate: NSPredicate(value: true))
        var records: [CKRecord] = []
        
        privateDB.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                for result in results {
                    records.append(result as! CKRecord)
                }
            }
            var tem: Bool!
            var record: CKRecord!
            
            for r in records {
                tem = false
                for d in self.disciplinas {
                    if r.valueForKey("id") as! NSNumber == d.id {
                        tem = true
                        println("Update d")
                        d.nome = r.valueForKey("nome") as! String
                        d.cor = r.valueForKey("cor") as! String
                        d.media = r.valueForKey("media") as! Double
                        DisciplinaManager.sharedInstance.salvarDisciplina()
                        println("Materia \(d.nome) Salva")
                    }
                }
                
                if !tem {
                    DisciplinaManager.sharedInstance.salvarDisciplinaCloud(r.valueForKey("nome") as! String, cor: r.valueForKey("cor") as! String, media: r.valueForKey("media") as! Double, id: r.valueForKey("id") as! Int)
                    
                    var nome = r.valueForKey("nome") as! String
                    
                    println("nova materia")
                    println("Materia \(nome) Salva")
                }
            }
            
            // Exclui registros não existentes
            for index in 0..<self.disciplinas.count {
                tem = false
                var d: Disciplina = self.disciplinas[index]
                for r in records {
                    if r.valueForKey("id") as! NSNumber == d.id {
                        tem = true
                    }
                }
                if !tem {
                    DisciplinaManager.sharedInstance.removerDisciplina(index)
                }
            }
        })
    }
    
    func CoreDataAtividades() {
        
        // Salva novos e atualiza registros existentes
        println("CoreData")
        
        let query = CKQuery(recordType: "Atividade", predicate: NSPredicate(value: true))
        var records: [CKRecord] = []
        
        privateDB.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                for result in results {
                    records.append(result as! CKRecord)
                }
            }
            var tem: Bool!
            var record: CKRecord!
            
            for r in records {
                tem = false
                var disciplina: Disciplina!
                for d in self.disciplinas {
                    if d.id == r.valueForKey("disciplina") as! NSNumber {
                        disciplina = d as Disciplina
                    }
                }
                for a in self.atividades {
                    if r.valueForKey("id") as! NSNumber == a.id {
                        tem = true
                        println("Update a")
                        a.concluido = r.valueForKey("concluido") as! Bool
                        a.data = r.valueForKey("data") as! NSDate
                        a.nome = r.valueForKey("nome") as! String
                        a.nota = r.valueForKey("nota") as! NSNumber
                        a.obs = r.valueForKey("obs") as! String
                        a.peso = r.valueForKey("peso") as! NSNumber
                        a.tipo = r.valueForKey("tipo") as! NSNumber
                        a.valeNota = r.valueForKey("valeNota") as! Bool
                        a.disciplina = disciplina
                        AtividadeManager.sharedInstance.salvarAtividade()
                        println("Atividade \(a.nome) Salva")
                    }
                }
                
                if !tem {
                    AtividadeManager.sharedInstance.salvarAtividadeCloud(r.valueForKey("nome") as! String, id: r.valueForKey("id") as! Int, nota: r.valueForKey("nota") as! Double, data: r.valueForKey("data") as! NSDate, materia: disciplina, peso: r.valueForKey("peso") as! Int, tipo: r.valueForKey("tipo") as! Int, valeNota: r.valueForKey("valeNota") as! Bool, obs: r.valueForKey("obs") as! String, concluido: r.valueForKey("concluido") as! Bool)
                    
                    var nome = r.valueForKey("nome") as! String
                    
                    println("nova atividade")
                    println("Atividade \(nome) Salva")
                }
            }
            
            // Exclui registros não existentes
            for a in self.atividades {
                tem = false
                for r in records {
                    if r.valueForKey("id") as! NSNumber == a.id {
                        tem = true
                    }
                }
                if !tem {
                    AtividadeManager.sharedInstance.removerAtividade(a.id.integerValue)
                }
            }
        })
    }
}