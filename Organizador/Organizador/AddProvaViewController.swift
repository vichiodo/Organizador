//
//  AddProvaViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 08/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class AddProvaViewController: UITableViewController{
    
    @IBOutlet weak var materias: UIPickerView!
    @IBOutlet weak var provaTxt: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    
    var materiasArray: NSArray = NSArray()
    var materiaSelecionada = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // impede de colocar uma data menor que a atual
        date.minimumDate = NSDate()
        
        //////////////////// PEGAR AS DISCIPLINAS DO COREDATA ////////////////////
        materiasArray = ["calculo", "fisica", "etica", "engenharia", "ciencia da computacao"]
        
    }
//    override func viewDidAppear(animated: Bool) {
//        materias.selectRow(materiasArray.count / 2, inComponent: 0, animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        default: return 0
        }
    }

    //MARK: - Delegates e data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return materiasArray.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return materiasArray[row] as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        materiaSelecionada = row
    }
    
    @IBAction func salvarProva(sender: AnyObject) {
        if provaTxt.text == "" {
            provaTxt.text = "Prova"
        }
        
        //////////////////// SALVAR NO COREDATA ////////////////////
        println("salvo - materia: \(materiasArray[materiaSelecionada]), nome: \(provaTxt.text), dia \(date.date)")
        
        criarNotificacao()
    }
    
    func criarNotificacao() {
        for i in 0...7 {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Ver a prova"
            var diasRestantes = 7 - i
            var strNotif = "\(provaTxt.text) de \(materiasArray[materiaSelecionada])"
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
}
