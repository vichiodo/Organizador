//
//  CalendarioViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 06/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit
import EventKit

class MateriasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewIntro: UIView!
    
    // carrega o vetor de usuarios cadastrados no CoreData
    lazy var disciplinas:Array<Disciplina> = {
        return DisciplinaManager.sharedInstance.buscarDisciplinas()
        }()
    
    lazy var atividades:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarAtividades()
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        disciplinas = DisciplinaManager.sharedInstance.buscarDisciplinas()
        self.tableView.reloadData()
        if disciplinas.isEmpty {
            viewIntro.hidden = false
        }
        else {
            viewIntro.hidden = true
        }
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disciplinas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("disciplinasCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = disciplinas[indexPath.row].nome
        cell.textLabel?.textColor = self.stringParaCor(disciplinas[indexPath.row].cor)
        cell.detailTextLabel?.text = "Média: \(disciplinas[indexPath.row].media)"
        cell.tag = indexPath.row
        //        cell.backgroundColor =
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
//            if atividades.count != 0 {
//                for i in 0...atividades.count - 1 {
//                    if atividades[i].disciplina == disciplinas[indexPath.row] {
//                        AtividadeManager.sharedInstance.removerAtividade(atividades[i].id as Int)
//                    }
//                }
//            }
            DisciplinaManager.sharedInstance.removerDisciplina(indexPath.row)
            disciplinas = DisciplinaManager.sharedInstance.buscarDisciplinas()

        }
        self.tableView.reloadData()
        if disciplinas.isEmpty {
            viewIntro.hidden = false
        }
        else {
            viewIntro.hidden = true
        }
    }
    
    // tranforma uma cor em hexa para um UIColor
    func stringParaCor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalhesDisciplinaView" {
            var cell = sender as! UITableViewCell
            let vC: AtividadesMateriaViewController = segue.destinationViewController as! AtividadesMateriaViewController
            vC.discliplinaSelecionada = disciplinas[cell.tag]
        }
    }
    
    
}
