//
//  DetalhesViewController.swift
//  Organizador
//
//  Created by Vivian Dias on 18/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class DetalhesViewController: UITableViewController {
    
    let vC: ProvasViewController = ProvasViewController()
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var materiaTxt: UITextField!
    @IBOutlet weak var notaTxt: UITextField!
    @IBOutlet weak var pesoTxt: UITextField!
    @IBOutlet weak var dataTxt: UITextField!
    @IBOutlet weak var obsTxt: UITextView!
    
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
        
        editarBtn = UIBarButtonItem(title: "Editar", style: .Plain, target: self, action: "editar")
        navigationItem.rightBarButtonItem = editarBtn
        
    }
    
    func editar() {
        if editarBtn.title == "Editar" {
            nomeTxt.userInteractionEnabled = true
            materiaTxt.userInteractionEnabled = true
            notaTxt.userInteractionEnabled = true
            pesoTxt.userInteractionEnabled = true
            dataTxt.userInteractionEnabled = true
            obsTxt.userInteractionEnabled = true
            
            nomeTxt.borderStyle = .RoundedRect
            materiaTxt.borderStyle = .RoundedRect
            notaTxt.borderStyle = .RoundedRect
            pesoTxt.borderStyle = .RoundedRect
            nomeTxt.borderStyle = .RoundedRect
            
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
            // quais dados vao poder mudar???
            // nome, disciplina??? , nota, peso, data??? (como escolher a data?), obs
            println("Nome antigo: \(atividadeSelecionada.nome)")
            
            var mediaAntigaAtividade = (atividadeSelecionada.peso.doubleValue/100) * atividadeSelecionada.nota.doubleValue
            atividadeSelecionada.disciplina.media = atividadeSelecionada.disciplina.media.doubleValue - mediaAntigaAtividade
            AtividadeManager.sharedInstance.salvarAtividade()

            atividadeSelecionada.nome = nomeTxt.text
            atividadeSelecionada.nota = notaTxt.text.toInt()!
            atividadeSelecionada.peso = pesoTxt.text.toInt()!
            atividadeSelecionada.obs = obsTxt.text
            
            ///////// VERIFICAR: NOTA ENTRE 0 E 10, PESO ENTRE 0 E 100%
            
            var mediaAtividade = (atividadeSelecionada.peso.doubleValue/100) * atividadeSelecionada.nota.doubleValue
            atividadeSelecionada.disciplina.media = atividadeSelecionada.disciplina.media.doubleValue + mediaAtividade
            println("media atividade \(mediaAtividade)")
            println("media materia \(atividadeSelecionada.disciplina.media)")
            AtividadeManager.sharedInstance.salvarAtividade()
            
            println("Nome novo: \(atividadeSelecionada.nome)")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        nomeTxt.text = atividadeSelecionada.nome
        materiaTxt.text = atividadeSelecionada.disciplina.nome
        notaTxt.text = "\(atividadeSelecionada.nota)"
        pesoTxt.text = "\(atividadeSelecionada.peso)"
        dataTxt.text = "\(atividadeSelecionada.data)"
        obsTxt.text = atividadeSelecionada.obs
        
        
        
        //                atividade.nota = NSNumber(integer: self.txtField!.text.toInt()!)
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        case 2: return 2
        default: return 0
        }
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
