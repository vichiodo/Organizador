//
//  AddProvaViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 08/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit
import EventKit

class AddProvaViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var materias: UIPickerView!
    @IBOutlet weak var provaTxt: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var valeNota: UISwitch!
    @IBOutlet weak var lblPerc: UILabel!
    @IBOutlet weak var lblPeso: UILabel!
    @IBOutlet weak var labelValeNota: UILabel!
    @IBOutlet weak var pesoTextField: UITextField!
    @IBOutlet weak var segmentedC: UISegmentedControl!
    @IBOutlet weak var txtObs: UITextView!
    
    var materiaSelecionada = 0
    var peso: Int?
    var vale: Bool!
    var tipo = 0
    var obs: String!
    
    var placeholderLabel : UILabel!
    
    // carrega o vetor de disciplinas cadastrados no CoreData
    lazy var disciplinas:Array<Disciplina> = {
        return DisciplinaManager.sharedInstance.buscarDisciplinas()
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provaTxt.delegate = self
        pesoTextField.delegate = self
        txtObs.delegate = self
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Digite suas observações aqui"
        placeholderLabel.font = UIFont.italicSystemFontOfSize(txtObs.font.pointSize)
        placeholderLabel.sizeToFit()
        txtObs.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, txtObs.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = count(txtObs.text) != 0
        
        // impede de colocar uma data menor que a atual
        date.minimumDate = NSDate()
        
        switch segmentedC.selectedSegmentIndex {
        case 0:
            println("PROVA")
            valeNota.hidden = true
            labelValeNota.hidden = true
            lblPeso.hidden = false
            lblPerc.hidden = false
            pesoTextField.hidden = false
        default:
            println("TRABALHO")
            valeNota.hidden = false
            labelValeNota.hidden = false
            lblPeso.hidden = true
            lblPerc.hidden = true
            pesoTextField.hidden = true
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
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if segmentedC.selectedSegmentIndex == 1 && valeNota.on {
                return 2
            }
            else {
                return 1
            }
        case 1: return 1
        case 2: return 2
        case 3: return 1
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if index == 0{
            return 1;
        }
        else
        {
            return 2;
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
        
        switch segmentedC.selectedSegmentIndex {
        case 0:
            peso = pesoTextField.text.toInt()
            tipo = 0
            if provaTxt.text == "" {
                provaTxt.text = "Prova"
            }
            vale = true
        default:
            if valeNota.on {
                peso = pesoTextField.text.toInt()
            } else {
                peso = 0
            }
            tipo = 1
            if provaTxt.text == "" {
                provaTxt.text = "Tarefa"
            }
            vale = valeNota.on
        }
        
        obs = txtObs.text
        
        
        if peso == nil {
            let alerta: UIAlertController = UIAlertController(title: "Digite o peso da atividade", message: nil, preferredStyle: .Alert)
            let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                pesoTextField.becomeFirstResponder()
            })
            [alerta.addAction(al1)]
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else {
            AtividadeManager.sharedInstance.salvarNovaAtividade(provaTxt.text, data: date.date, materia: disciplinas[materiaSelecionada], peso: peso!, tipo: tipo, valeNota: vale, obs: obs)
            
            criarNotificacao()
            criarEventoCalendario()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
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
    func criarEventoCalendario(){
        var eventStore: EKEventStore = EKEventStore()
        
        var evento: EKEvent = EKEvent(eventStore: eventStore)
        
        evento.title = "\(provaTxt.text) de \(disciplinas[materiaSelecionada].nome)"
        
        evento.startDate = date.date
        
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
    
    @IBAction func segControl(sender: AnyObject) {
        switch segmentedC.selectedSegmentIndex {
        case 0:
            valeNota.on = false
            println("PROVA")
            valeNota.hidden = true
            labelValeNota.hidden = true
            lblPerc.hidden = false
            lblPeso.hidden = false
            pesoTextField.hidden = false
            txtObs.hidden = false
            provaTxt.placeholder = "Nome da Prova"
        default:
            println("TRABALHO")
            valeNota.hidden = false
            labelValeNota.hidden = false
            lblPerc.hidden = true
            lblPeso.hidden = true
            pesoTextField.hidden = true
            txtObs.hidden = false
            provaTxt.placeholder = "Nome da Tarefa"
        }
        self.tableView.reloadData()
    }
    
    @IBAction func valeNotaMudou(sender: UISwitch) {
        self.tableView.reloadData()
    }
    
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = count(textView.text) != 0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
