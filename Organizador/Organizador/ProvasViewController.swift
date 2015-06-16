//
//  ProvasViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 06/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class ProvasViewController: UITableViewController {

    @IBOutlet weak var segmentedC: UISegmentedControl!
    
    
    // carrega o vetor de atividades cadastradas no CoreData
    lazy var materias:Array<Disciplina> = {
        return DisciplinaManager.sharedInstance.buscarDisciplinas()
        }()
    
    lazy var atividades:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarAtividades()
        }()
    
    lazy var provas:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarProvas()
        }()

    lazy var tarefas:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarTarefas()
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        atividades = AtividadeManager.sharedInstance.buscarAtividades()
        provas = AtividadeManager.sharedInstance.buscarProvas()
        tarefas = AtividadeManager.sharedInstance.buscarTarefas()
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return materias.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return atividades.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("atividadesCell", forIndexPath: indexPath) as! UITableViewCell
        var ativi: Array<Atividade>!
        
        if segmentedC.selectedSegmentIndex == 0{
            ativi = AtividadeManager.sharedInstance.buscarAtividadesNaoConcluidas()
//            switch section {
//            case 0:
                    cell.textLabel?.text = ativi[indexPath.row].nome
                    cell.detailTextLabel?.text = ativi[indexPath.row].disciplina.nome
          //  }
        }
        else{
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            ativi = AtividadeManager.sharedInstance.buscarAtividadesConcluidas()
            if ativi.count != 0{
                cell.textLabel?.text = ativi[indexPath.row].nome
                cell.detailTextLabel?.text = ativi[indexPath.row].disciplina.nome
            }
        }
        
        return cell
    }

    @IBAction func mudarTable(sender: AnyObject) {
        self.tableView.reloadData()
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
