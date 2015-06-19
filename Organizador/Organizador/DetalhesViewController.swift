//
//  DetalhesViewController.swift
//  Organizador
//
//  Created by Vivian Dias on 18/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit
import EventKit

class DetalhesViewController: UITableViewController {
    
//    let vC: ProvasViewController = ProvasViewController()
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var materiaTxt: UITextField!
    @IBOutlet weak var notaTxt: UITextField!
    @IBOutlet weak var pesoTxt: UITextField!
    @IBOutlet weak var dataTxt: UITextField!
    @IBOutlet weak var obsTxt: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cellData: UITableViewCell!
    @IBOutlet weak var cellDateP: UITableViewCell!
    
    var atividadeSelecionada: Atividade!
    
    var editarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nomeTxt.userInteractionEnabled = false
        materiaTxt.userInteractionEnabled = false
        notaTxt.userInteractionEnabled = false
        pesoTxt.userInteractionEnabled = false
        dataTxt.userInteractionEnabled = false
        obsTxt.userInteractionEnabled = false
        cellDateP.hidden = true
        datePicker.userInteractionEnabled = false
        
        
        editarBtn = UIBarButtonItem(title: "Editar", style: .Plain, target: self, action: "editar")
        navigationItem.rightBarButtonItem = editarBtn
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        nomeTxt.text = atividadeSelecionada.nome
        materiaTxt.text = atividadeSelecionada.disciplina.nome
        notaTxt.text = "\(atividadeSelecionada.nota)"
        pesoTxt.text = "\(atividadeSelecionada.peso)"
        dataTxt.text = "\(atividadeSelecionada.data)"
        obsTxt.text = atividadeSelecionada.obs
        datePicker.date = atividadeSelecionada.data
        
        
        
        //                atividade.nota = NSNumber(integer: self.txtField!.text.toInt()!)
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        case 2:
            if atividadeSelecionada.concluido == 0{
                return 3
            }
            cellDateP.hidden = true
            return 1
        default: return 0
        }
    }

    
    func editar() {
        if editarBtn.title == "Editar" {
            if atividadeSelecionada.concluido == 0 {
                nomeTxt.userInteractionEnabled = true
                pesoTxt.userInteractionEnabled = true
                obsTxt.userInteractionEnabled = true
                cellDateP.hidden = false
                datePicker.userInteractionEnabled = true
                
                nomeTxt.borderStyle = .RoundedRect
                pesoTxt.borderStyle = .RoundedRect
                
            } else {
                notaTxt.userInteractionEnabled = true
                nomeTxt.userInteractionEnabled = true
                pesoTxt.userInteractionEnabled = true
                obsTxt.userInteractionEnabled = true
                
                nomeTxt.borderStyle = .RoundedRect
                notaTxt.borderStyle = .RoundedRect
                pesoTxt.borderStyle = .RoundedRect
            }
            
            editarBtn.title = "Salvar"
            
        } else {
            nomeTxt.userInteractionEnabled = false
            materiaTxt.userInteractionEnabled = false
            notaTxt.userInteractionEnabled = false
            pesoTxt.userInteractionEnabled = false
            dataTxt.userInteractionEnabled = false
            obsTxt.userInteractionEnabled = false
            
            nomeTxt.borderStyle = .None
            materiaTxt.borderStyle = .None
            notaTxt.borderStyle = .None
            pesoTxt.borderStyle = .None
            nomeTxt.borderStyle = .None
            
            editarBtn.title = "Editar"
            
            
            ///////////// MUDAR OS DADOS DO COREDATA!!! //////////////////
            
            println("Nome antigo: \(atividadeSelecionada.nome)")
            
            var mediaAntigaAtividade = (atividadeSelecionada.peso.doubleValue/100) * atividadeSelecionada.nota.doubleValue
            atividadeSelecionada.disciplina.media = atividadeSelecionada.disciplina.media.doubleValue - mediaAntigaAtividade
            
            if dataTxt != datePicker.date {
                excluirEventoCalendario(atividadeSelecionada.nome, materia: atividadeSelecionada.disciplina, data: atividadeSelecionada.data)
                cancelarNotificacao(atividadeSelecionada.nome, materia: atividadeSelecionada.disciplina, data: atividadeSelecionada.data)
                atividadeSelecionada.data = datePicker.date
                criarNotificacao(nomeTxt.text, materia: atividadeSelecionada.disciplina, data: datePicker.date)
//                criarEventoCalendario(nomeTxt.text, materia: atividadeSelecionada.disciplina, data: datePicker.date)
            }

            atividadeSelecionada.nome = nomeTxt.text
            atividadeSelecionada.nota = notaTxt.text.toInt()!
            atividadeSelecionada.peso = pesoTxt.text.toInt()!
            atividadeSelecionada.obs = obsTxt.text
            
            
            ///////// VERIFICAR: NOTA ENTRE 0 E 10, PESO ENTRE 0 E 100%
            var mediaAtividade: Double!
            
            if (atividadeSelecionada.peso.doubleValue >= 0 && atividadeSelecionada.peso.doubleValue <= 100){
                if (atividadeSelecionada.nota.doubleValue >= 0 && atividadeSelecionada.nota.doubleValue <= 10) {
                    mediaAtividade = (atividadeSelecionada.peso.doubleValue/100) * atividadeSelecionada.nota.doubleValue
                    println("\(mediaAtividade)")
                    
                    atividadeSelecionada.disciplina.media = atividadeSelecionada.disciplina.media.doubleValue + mediaAtividade
                    println("media atividade \(mediaAtividade)")
                    println("media materia \(atividadeSelecionada.disciplina.media)")
                    
                    println("Nome novo: \(atividadeSelecionada.nome)")
                    
                    println("\(atividadeSelecionada.concluido)")
                    
                }else {
                    // Aviso de que a nota esta inválida
                    // Não pode deixar salvar
                    println("NOTA INVÁLIDA")
                }
            } else {
                // Aviso de que o peso esta incorreto
                // Não pode deixar salvar
                println("PESO INVÁLIDO")
            }
            AtividadeManager.sharedInstance.salvarAtividade()
            self.navigationController?.popToRootViewControllerAnimated(true)

        }
        
    }
    
    func criarNotificacao(nome: NSString, materia: Disciplina, data: NSDate) {
        for i in 0...7 {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Ver a prova"
            var diasRestantes = 7 - i
            var strNotif = "\(nome) de \(materia.nome)"
            if diasRestantes == 0 {
                localNotification.alertBody = "Vish, a '\(strNotif)' é hoje!"
            }
            else if diasRestantes == 1 {
                localNotification.alertBody = "Vish, falta \(diasRestantes) dia para a '\(strNotif)'!"
            }
            else {
                localNotification.alertBody = "Vish, faltam \(diasRestantes) dias para a '\(strNotif)'!"
            }
            
            let dateFix: NSTimeInterval = floor(data.timeIntervalSinceReferenceDate / 60.0) * 60.0
            var horario: NSDate = NSDate(timeIntervalSinceReferenceDate: dateFix)
            
            let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
            
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber = 1
            
            localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    func cancelarNotificacao(nome: NSString, materia: Disciplina, data: NSDate) {
        for i in 0...7 {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Ver a prova"
            var diasRestantes = 7 - i
            var strNotif = "\(nome) de \(materia.nome)"
            if diasRestantes == 0 {
                localNotification.alertBody = "Vish, a '\(strNotif)' é hoje!"
            }
            else if diasRestantes == 1 {
                localNotification.alertBody = "Vish, falta \(diasRestantes) dia para a '\(strNotif)'!"
            }
            else {
                localNotification.alertBody = "Vish, faltam \(diasRestantes) dias para a '\(strNotif)'!"
            }
            
            let dateFix: NSTimeInterval = floor(data.timeIntervalSinceReferenceDate / 60.0) * 60.0
            var horario: NSDate = NSDate(timeIntervalSinceReferenceDate: dateFix)
            
            let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
            
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber = 1
            
            localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
            UIApplication.sharedApplication().cancelLocalNotification(localNotification)
        }
    }
    
    //método que salva no calendário nativo a atividade
    func criarEventoCalendario(nome: NSString, materia: Disciplina, data: NSDate){
        var eventStore: EKEventStore = EKEventStore()
        
        var evento: EKEvent = EKEvent(eventStore: eventStore)
        
        evento.title = "\(nome) de \(materia.nome)"
        
        evento.startDate = data
        
        evento.endDate = NSDate(timeInterval: 3600, sinceDate: evento.startDate)
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error NSError) -> Void in
            if !granted {
                return
            } else {
                evento.calendar = eventStore.defaultCalendarForNewEvents
                
                eventStore.saveEvent(evento, span: EKSpanThisEvent, commit: true, error: NSErrorPointer())
            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //excluir evento do calendário
    func excluirEventoCalendario(nome: NSString, materia: Disciplina, data: NSDate){
        var eventStore = EKEventStore()
        
        var endData: NSDate = NSDate(timeInterval: 3600, sinceDate: data)
        
        var predicate = eventStore.predicateForEventsWithStartDate(data, endDate: endData, calendars:[eventStore.defaultCalendarForNewEvents])
        
        var eventos = eventStore.eventsMatchingPredicate(predicate)
        
        eventStore.removeEvent((eventos.last as! EKEvent), span: EKSpanThisEvent, error: NSErrorPointer())
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
