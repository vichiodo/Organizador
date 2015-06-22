//
//  DetalhesViewController.swift
//  Organizador
//
//  Created by Vivian Dias on 18/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit
import EventKit

class DetalhesAtividadeViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var materiaTxt: UITextField!
    @IBOutlet weak var notaTxt: UITextField!
    @IBOutlet weak var pesoTxt: UITextField!
    @IBOutlet weak var dataTxt: UITextField!
    @IBOutlet weak var obsTxt: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cellData: UITableViewCell!
    @IBOutlet weak var cellDateP: UITableViewCell!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var atividadeSelecionada: Atividade!
    
    var editarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // impede de colocar uma data menor que a atual
        datePicker.minimumDate = NSDate()

        nomeTxt.userInteractionEnabled = false
        materiaTxt.userInteractionEnabled = false
        notaTxt.userInteractionEnabled = false
        pesoTxt.userInteractionEnabled = false
        dataTxt.userInteractionEnabled = false
        obsTxt.userInteractionEnabled = false
        cellDateP.hidden = true
        datePicker.userInteractionEnabled = false
        
        if atividadeSelecionada != nil{
            self.navigationItem.title = atividadeSelecionada.nome
        }
        editarBtn = UIBarButtonItem(title: "Editar", style: .Plain, target: self, action: "editar")
        navigationItem.rightBarButtonItem = editarBtn
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if atividadeSelecionada != nil{
            nomeTxt.text = atividadeSelecionada.nome
            materiaTxt.text = atividadeSelecionada.disciplina.nome
            notaTxt.text = "\(atividadeSelecionada.nota)"
            pesoTxt.text = "\(atividadeSelecionada.peso)"
            
            obsTxt.text = atividadeSelecionada.obs
            datePicker.date = atividadeSelecionada.data
            
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
            var dateString = dateFormatter.stringFromDate(atividadeSelecionada.data)
            dataTxt.text = dateString
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if atividadeSelecionada != nil{
            return 3
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if atividadeSelecionada != nil{
            switch section {
            case 0: return 2
            case 1: return 2
            case 2:
                if atividadeSelecionada.concluido == 0 {
                    return 3
                }
                cellDateP.hidden = true
                return 2
            default: return 0
            }
        }
        return 0
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
                obsTxt.userInteractionEnabled = false
                
                nomeTxt.borderStyle = .RoundedRect
                notaTxt.borderStyle = .RoundedRect
                pesoTxt.borderStyle = .RoundedRect
            }
            
            editarBtn.title = "Salvar"
            
        } else {
            if dataTxt != datePicker.date {
                excluirEventoCalendario(atividadeSelecionada.nome, materia: atividadeSelecionada.disciplina, data: atividadeSelecionada.data)
                cancelarNotificacao(atividadeSelecionada.nome, materia: atividadeSelecionada.disciplina, data: atividadeSelecionada.data)
                atividadeSelecionada.data = datePicker.date

                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
                var dateString = dateFormatter.stringFromDate(atividadeSelecionada.data)
                dataTxt.text = dateString

                
                criarNotificacao(nomeTxt.text, materia: atividadeSelecionada.disciplina, data: datePicker.date)
                criarEventoCalendario(nomeTxt.text, materia: atividadeSelecionada.disciplina, data: datePicker.date)
            }
            
            if (pesoTxt.text.toInt() >= 0 && pesoTxt.text.toInt() <= 100){
                if ((notaTxt.text as NSString).doubleValue >= 0 && (notaTxt.text as NSString).doubleValue <= 10) {
                    
                    var mediaAntigaAtividade = (atividadeSelecionada.peso.doubleValue/100) * atividadeSelecionada.nota.doubleValue
                    atividadeSelecionada.disciplina.media = atividadeSelecionada.disciplina.media.doubleValue - mediaAntigaAtividade
                    
                    atividadeSelecionada.nome = nomeTxt.text
                    atividadeSelecionada.nota = (notaTxt.text as NSString).doubleValue
                    atividadeSelecionada.peso = pesoTxt.text.toInt()!
                    atividadeSelecionada.obs = obsTxt.text

                    var mediaAtividade = (atividadeSelecionada.peso.doubleValue/100) * atividadeSelecionada.nota.doubleValue
                    
                    atividadeSelecionada.disciplina.media = atividadeSelecionada.disciplina.media.doubleValue + mediaAtividade
                    AtividadeManager.sharedInstance.salvarAtividade()
                    
                    nomeTxt.userInteractionEnabled = false
                    materiaTxt.userInteractionEnabled = false
                    notaTxt.userInteractionEnabled = false
                    pesoTxt.userInteractionEnabled = false
                    dataTxt.userInteractionEnabled = false
                    obsTxt.userInteractionEnabled = false
                    cellDateP.hidden = true
                    
                    nomeTxt.borderStyle = .None
                    materiaTxt.borderStyle = .None
                    notaTxt.borderStyle = .None
                    pesoTxt.borderStyle = .None
                    nomeTxt.borderStyle = .None
                    
                    editarBtn.title = "Editar"
                } else {
                    // Aviso de que a nota esta inválida
                    // Não pode deixar salvar
                    let alerta: UIAlertController = UIAlertController(title: "Nota inválida", message: "Digite uma nota entre 0 e 10", preferredStyle: .Alert)
                    let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                        self.notaTxt.becomeFirstResponder()
                        self.notaTxt.text = "\(self.atividadeSelecionada.nota)"
                    })
                    [alerta.addAction(al1)]
                    self.presentViewController(alerta, animated: true, completion: nil)

                }
            } else {
                // Aviso de que o peso esta incorreto
                // Não pode deixar salvar
                let alerta: UIAlertController = UIAlertController(title: "Peso inválido", message: "Digite um peso entre 0% e 100%", preferredStyle: .Alert)
                let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                    self.pesoTxt.becomeFirstResponder()
                    self.pesoTxt.text = "\(self.atividadeSelecionada.peso)"
                })
                [alerta.addAction(al1)]
                self.presentViewController(alerta, animated: true, completion: nil)
            }
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
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            tableView.reloadData()
        }
    }

}
