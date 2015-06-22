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
            if dataTxt != datePicker.date || nomeTxt.text != atividadeSelecionada.nome {
                EventHelper.shared.excluirEventoCalendario(atividadeSelecionada)
                EventHelper.shared.cancelarNotificacao(atividadeSelecionada)
                atividadeSelecionada.data = datePicker.date
                atividadeSelecionada.nome = nomeTxt.text

                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
                var dateString = dateFormatter.stringFromDate(atividadeSelecionada.data)
                dataTxt.text = dateString
                
                EventHelper.shared.criarNotificacao(atividadeSelecionada)
                EventHelper.shared.criarEventoCalendario(atividadeSelecionada)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            atividadeSelecionada = detailItem as! Atividade
            tableView.reloadData()
        }
    }

}
