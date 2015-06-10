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
        println("salvo, materia: \(materiasArray[materiaSelecionada]), nome da prova: \(provaTxt.text)")
        
    }
}
