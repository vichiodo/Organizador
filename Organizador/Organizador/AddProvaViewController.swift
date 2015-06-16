//
//  AddProvaViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 08/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit
import EventKit

class AddProvaViewController: UITableViewController{
    
    @IBOutlet weak var materias: UIPickerView!
    @IBOutlet weak var provaTxt: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var valeNota: UISwitch!
    @IBOutlet weak var labelValeNota: UILabel!
    @IBOutlet weak var pesoTextField: UITextField!
    @IBOutlet weak var segmentedC: UISegmentedControl!
    
    var materiaSelecionada = 0
    
    // carrega o vetor de usuarios cadastrados no CoreData
    lazy var disciplinas:Array<Disciplina> = {
        return DisciplinaManager.sharedInstance.buscarDisciplinas()
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // impede de colocar uma data menor que a atual
        date.minimumDate = NSDate()
        
        switch segmentedC.selectedSegmentIndex {
        case 0:
            println("PROVA")
            valeNota.hidden = true
            pesoTextField.hidden = false
            labelValeNota.text = "Peso"
            
        default:
            println("TRABALHO")
            valeNota.hidden = false
            pesoTextField.hidden = true
            labelValeNota.text = "Vale nota? "
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        disciplinas = DisciplinaManager.sharedInstance.buscarDisciplinas()
        self.materias.reloadAllComponents()
        
        if disciplinas.isEmpty {
            let alerta: UIAlertController = UIAlertController(title: "Adicione uma matéria", message: "Para então poder adicionar uma atividade nova", preferredStyle: .Alert)
            let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("addDisciplinas")
                self.showViewController(vc as! UIViewController, sender: vc)

            })
            [alerta.addAction(al1)]
            self.presentViewController(alerta, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 2
        default: return 0
        }
    }

    //MARK: - Delegates e data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return disciplinas.count
    }
    
    
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return disciplinas[row].nome
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        materiaSelecionada = row
    }
    
    @IBAction func salvarProva(sender: AnyObject) {
        if provaTxt.text == "" {
            provaTxt.text = "Prova"
        }
        
        //////////////////// SALVAR NO COREDATA ////////////////////
        println("salvo - materia: \(disciplinas[materiaSelecionada].nome), nome: \(provaTxt.text), dia \(date.date)")
        
        criarNotificacao()
        criarEventoCalendario()
    }
    
    func criarNotificacao() {
        for i in 0...7 {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Ver a prova"
            var diasRestantes = 7 - i
            var strNotif = "\(provaTxt.text) de \(disciplinas[materiaSelecionada].nome)"
            if diasRestantes == 0 {
                localNotification.alertBody = "Vish, a '\(strNotif)' é hoje!"
            }
            else if diasRestantes == 1 {
                localNotification.alertBody = "Vish, falta \(diasRestantes) dia para a '\(strNotif)'!"
            }
            else {
                localNotification.alertBody = "Vish, faltam \(diasRestantes) dias para a '\(strNotif)'!"
            }
            
            let dateFix: NSTimeInterval = floor(date.date.timeIntervalSinceReferenceDate / 60.0) * 60.0
            var horario: NSDate = NSDate(timeIntervalSinceReferenceDate: dateFix)
            
            let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
            
            localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            println("notificacao \(i) criada - \(localNotification.fireDate!) - nome \(localNotification.alertBody!)")
        }
    }
    
    //método que salva no calendário nativo a atividade
    func criarEventoCalendario(){
        var eventStore: EKEventStore = EKEventStore()
        
        var evento: EKEvent = EKEvent(eventStore: eventStore)
        
        evento.title = "\(provaTxt.text) de \(disciplinas[materiaSelecionada].nome)"
        
        evento.startDate = date.date
        
        evento.endDate = NSDate(timeInterval: 600, sinceDate: evento.startDate)
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error NSError) -> Void in
            if !granted {
                return
            }else {
                evento.calendar = eventStore.defaultCalendarForNewEvents
                
                eventStore.saveEvent(evento, span: EKSpanThisEvent, commit: true, error: NSErrorPointer())
            }
        })
    }
    
    @IBAction func segControl(sender: AnyObject) {
        switch segmentedC.selectedSegmentIndex {
        case 0:
            println("PROVA")
            valeNota.hidden = true
            pesoTextField.hidden = false
            labelValeNota.text = "Peso"
        default:
            println("TRABALHO")
            valeNota.hidden = false
            pesoTextField.hidden = true
            labelValeNota.text = "Vale nota? "
        }
    }
    
}
