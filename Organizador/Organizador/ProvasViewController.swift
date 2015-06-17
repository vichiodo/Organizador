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
    var atividadesOrdenadas: Array<Atividade>!
    var provasOrdenadas: Array<Atividade>!
    var tarefasOrdenadas: Array<Atividade>!
    
    var atividades7Dias: Array<Atividade> = []
    var atividades15Dias: Array<Atividade> = []
    var atividades30Dias: Array<Atividade> = []
    var atividades30MaisDias: Array<Atividade> = []
    
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
        self.atualiza_OrdenaVetores()
        
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
        case 0: return atividades7Dias.count
        case 1: return atividades15Dias.count
        case 2: return atividades30Dias.count
        case 3: return atividades30MaisDias.count
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "7 dias"
        case 1: return "15 dias"
        case 2: return "30 dias"
        case 3: return "30+ dias"
        default: return ""
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("atividadesCell", forIndexPath: indexPath) as! UITableViewCell
        //        var ativi: Array<Atividade>!
        
        //        if segmentedC.selectedSegmentIndex == 0 {
        //            println("primeiro")
        //            ativi = AtividadeManager.sharedInstance.buscarAtividadesNaoConcluidas()
        ////            switch section {
        ////            case 0:
        //                    cell.textLabel?.text = ativi[indexPath.row].nome
        //                    cell.detailTextLabel?.text = ativi[indexPath.row].disciplina.nome
        //          //  }
        //        }
        //        else{
        //            println("segundo")
        //
        //            cell.textLabel?.text = ""
        //            cell.detailTextLabel?.text = ""
        //            ativi = AtividadeManager.sharedInstance.buscarAtividadesConcluidas()
        //            if ativi.count != 0{
        //                cell.textLabel?.text = ativi[indexPath.row].nome
        //                cell.detailTextLabel?.text = ativi[indexPath.row].disciplina.nome
        //            }
        //        }
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = atividades7Dias[indexPath.row].nome
            cell.detailTextLabel?.text = atividades7Dias[indexPath.row].disciplina.nome
        case 1:
            cell.textLabel?.text = atividades15Dias[indexPath.row].nome
            cell.detailTextLabel?.text = atividades15Dias[indexPath.row].disciplina.nome
        case 2:
            cell.textLabel?.text = atividades30Dias[indexPath.row].nome
            cell.detailTextLabel?.text = atividades30Dias[indexPath.row].disciplina.nome
        case 3:
            cell.textLabel?.text = atividades30MaisDias[indexPath.row].nome
            cell.detailTextLabel?.text = atividades30MaisDias[indexPath.row].disciplina.nome
        default:
            break
        }
        
        return cell
    }
    
    
    @IBAction func mudarTable(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    func atualiza_OrdenaVetores() {
        atividades = AtividadeManager.sharedInstance.buscarAtividades()
        provas = AtividadeManager.sharedInstance.buscarProvas()
        tarefas = AtividadeManager.sharedInstance.buscarTarefas()
        
        atividadesOrdenadas = atividades
        atividadesOrdenadas.sort({$0.data.timeIntervalSinceNow < $1.data.timeIntervalSinceNow })
        
        provasOrdenadas = provas
        provasOrdenadas.sort({$0.data.timeIntervalSinceNow < $1.data.timeIntervalSinceNow })
        
        tarefasOrdenadas = tarefas
        tarefasOrdenadas.sort({$0.data.timeIntervalSinceNow < $1.data.timeIntervalSinceNow })
        
        atividades7Dias = []
        atividades15Dias = []
        atividades30Dias = []
        atividades30MaisDias = []
        
        // organiza as atividades dentro de cada periodo de tempo
        if atividadesOrdenadas.count > 0 {
            for i in 0...atividadesOrdenadas.count - 1 {
                let dataCompara = atividadesOrdenadas[i].data
                
                let calendar = NSCalendar.currentCalendar()
                let comps30 = NSDateComponents()
                comps30.day = 30
                let date30 = calendar.dateByAddingComponents(comps30, toDate: NSDate(), options: NSCalendarOptions.allZeros)
                
                let comps15 = NSDateComponents()
                comps15.day = 15
                let date15 = calendar.dateByAddingComponents(comps15, toDate: NSDate(), options: NSCalendarOptions.allZeros)
                
                let comps7 = NSDateComponents()
                comps7.day = 7
                let date7 = calendar.dateByAddingComponents(comps7, toDate: NSDate(), options: NSCalendarOptions.allZeros)
                
                
                if dataCompara.compare(date30!) == NSComparisonResult.OrderedDescending {
                    atividades30MaisDias.append(atividadesOrdenadas[i])
                } else if dataCompara.compare(date30!) == NSComparisonResult.OrderedAscending {
                    if dataCompara.compare(date15!) == NSComparisonResult.OrderedDescending {
                        atividades30Dias.append(atividadesOrdenadas[i])
                    } else {
                        if dataCompara.compare(date7!) == NSComparisonResult.OrderedDescending {
                            atividades15Dias.append(atividadesOrdenadas[i])
                        } else {
                            atividades7Dias.append(atividadesOrdenadas[i])
                        }
                    }
                }
            }
        }
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
