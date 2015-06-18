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
        
        // Registra o xib da Célula
        var nibP : UINib = UINib(nibName: "CellProva", bundle: nil);
        tableView.registerNib(nibP, forCellReuseIdentifier: "CellProva");
        var nibT : UINib = UINib(nibName: "CellTarefa", bundle: nil);
        tableView.registerNib(nibT, forCellReuseIdentifier: "CellTarefa");
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
        
        var ativ: Atividade!
        
        switch indexPath.section {
        case 0:
            ativ = atividades7Dias[indexPath.row]
        case 1:
            ativ = atividades15Dias[indexPath.row]
        case 2:
            ativ = atividades30Dias[indexPath.row]
        case 3:
            ativ = atividades30Dias[indexPath.row]
        default:
            break
        }        
        var cell: UITableViewCell!
        
        if ativ.tipo == 0 {
            let cell: CellProva = tableView.dequeueReusableCellWithIdentifier("CellProva", forIndexPath: indexPath) as! CellProva
            cell.barra.layer.cornerRadius = cell.barra.frame.size.height/2
            cell.barra.clipsToBounds = true
            cell.date.layer.cornerRadius = cell.date.frame.size.height/2
            cell.date.clipsToBounds = true
            
            cell.title.text = ativ.nome
            cell.date.textColor = stringParaCor(ativ.disciplina.cor)
            cell.matIcon.text = ativ.disciplina.nome
            cell.barra.backgroundColor = stringParaCor(ativ.disciplina.cor)
            return cell
        }
        else{
            let cell: CellTarefa = tableView.dequeueReusableCellWithIdentifier("CellTarefa", forIndexPath: indexPath) as! CellTarefa
            
            cell.title.text = ativ.nome
            cell.date.textColor = stringParaCor(ativ.disciplina.cor)
            cell.matIcon.text = ativ.disciplina.nome
            cell.barra.backgroundColor = stringParaCor(ativ.disciplina.cor)
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let vC: AddProvaViewController = AddProvaViewController()
            
            switch indexPath.section {
            case 0:
                vC.cancelarNotificacao(atividades7Dias[indexPath.row].nome, materia: atividades7Dias[indexPath.row].disciplina, data: atividades7Dias[indexPath.row].data)
                AtividadeManager.sharedInstance.removerAtividade(atividades7Dias[indexPath.row].id as Int)
            case 1:
                vC.cancelarNotificacao(atividades15Dias[indexPath.row].nome, materia: atividades15Dias[indexPath.row].disciplina, data: atividades15Dias[indexPath.row].data)
                AtividadeManager.sharedInstance.removerAtividade(atividades15Dias[indexPath.row].id as Int)
            case 2:
                vC.cancelarNotificacao(atividades30Dias[indexPath.row].nome, materia: atividades30Dias[indexPath.row].disciplina, data: atividades30Dias[indexPath.row].data)
                AtividadeManager.sharedInstance.removerAtividade(atividades30Dias[indexPath.row].id as Int)
            case 3:
                vC.cancelarNotificacao(atividades30MaisDias[indexPath.row].nome, materia: atividades30MaisDias[indexPath.row].disciplina, data: atividades30MaisDias[indexPath.row].data)
                AtividadeManager.sharedInstance.removerAtividade(atividades30MaisDias[indexPath.row].id as Int)
            default:
                break
            }
        }
        atualiza_OrdenaVetores()
    }
    
    func mudarTable(sender: AnyObject) {
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

    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
