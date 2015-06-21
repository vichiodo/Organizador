//
//  ProvasViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 06/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class AtividadesViewController: UITableViewController {
    
    @IBOutlet weak var segmentedC: UISegmentedControl!
    var atividadesOrdenadas: Array<Atividade>!
    var provasOrdenadas: Array<Atividade>!
    var tarefasOrdenadas: Array<Atividade>!
    
    var atividades7Dias: Array<Atividade> = []
    var atividades15Dias: Array<Atividade> = []
    var atividades30Dias: Array<Atividade> = []
    var atividades30MaisDias: Array<Atividade> = []
    var atividadesConcluidas: Array<Atividade> = []
    
    var atividadeSelecionada: Atividade!
    
    // carrega o vetor de atividades cadastradas no CoreData
    lazy var disciplinas:Array<Disciplina> = {
        return DisciplinaManager.sharedInstance.buscarDisciplinas()
        }()
    
    lazy var atividades:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarAtividades()
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Registra o xib da Célula
        var nibT : UINib = UINib(nibName: "CellAtividade", bundle: nil);
        tableView.registerNib(nibT, forCellReuseIdentifier: "CellAtividade");
    }
    
    override func viewWillAppear(animated: Bool) {
        self.atualiza_OrdenaVetores()
        if !atividadesConcluidas.isEmpty {
            for i in 0...atividadesConcluidas.count - 1 {
                var ativ = atividadesConcluidas[i]
                ativ.concluido = 1
                AtividadeManager.sharedInstance.salvarAtividade()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if segmentedC.selectedSegmentIndex == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedC.selectedSegmentIndex == 0 {
            switch section {
            case 0: return atividades7Dias.count
            case 1: return atividades15Dias.count
            case 2: return atividades30Dias.count
            case 3: return atividades30MaisDias.count
            default: return 0
            }
        }
        else {
            return atividadesConcluidas.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedC.selectedSegmentIndex == 0 {
            switch section {
            case 0: return "7 dias"
            case 1: return "15 dias"
            case 2: return "30 dias"
            case 3: return "30+ dias"
            default: return ""
            }
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var ativ: Atividade!
        
        if segmentedC.selectedSegmentIndex == 0 {
            switch indexPath.section {
            case 0:
                ativ = atividades7Dias[indexPath.row]
            case 1:
                ativ = atividades15Dias[indexPath.row]
            case 2:
                ativ = atividades30Dias[indexPath.row]
            case 3:
                ativ = atividades30MaisDias[indexPath.row]
            default:
                break
            }
            
            let dataAtividade = ativ.data
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitDay | .CalendarUnitMonth, fromDate:  dataAtividade)
            let diaAtividade = components.day
            let mesAtividade = components.month
            
            
            var dataString: NSString = "\(mesAtividade)"
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            dateFormatter.dateFormat = "MM"
            var myDate: NSDate = dateFormatter.dateFromString(dataString as String)!
            dateFormatter.dateFormat = "MMM"
            var aux: NSString = dateFormatter.stringFromDate(myDate)
            var mesString = aux.uppercaseString
            
            var cor = stringParaCor(ativ.disciplina.cor)
            
            let cell: CellAtividade = tableView.dequeueReusableCellWithIdentifier("CellAtividade", forIndexPath: indexPath) as! CellAtividade
            
            cell.title.text = ativ.nome
            cell.date.text = "\(diaAtividade)\n\(mesString)"
            cell.date.textColor = cor
            cell.matIcon.text = ativ.disciplina.nome
            cell.barra.backgroundColor = cor
            cell.back.backgroundColor = cor
            
            if ativ.tipo == 0 {
                cell.barra.hidden = false
            }
            else {
                cell.barra.hidden = true
            }
            
            return cell
            
        } else {
            ativ = atividadesConcluidas[indexPath.row]
            let dataAtividade = ativ.data
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitDay | .CalendarUnitMonth, fromDate:  dataAtividade)
            let diaAtividade = components.day
            let mesAtividade = components.month
            
            
            var dataString: NSString = "\(mesAtividade)"
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            dateFormatter.dateFormat = "MM"
            var myDate: NSDate = dateFormatter.dateFromString(dataString as String)!
            dateFormatter.dateFormat = "MMM"
            var aux: NSString = dateFormatter.stringFromDate(myDate)
            var mesString = aux.uppercaseString
            
            var cor = stringParaCor(ativ.disciplina.cor)
            
            let cell: CellAtividade = tableView.dequeueReusableCellWithIdentifier("CellAtividade", forIndexPath: indexPath) as! CellAtividade
            
            cell.title.text = ativ.nome
            cell.date.text = "\(diaAtividade)\n\(mesString)"
            cell.date.textColor = cor
            cell.matIcon.text = ativ.disciplina.nome
            cell.barra.backgroundColor = cor
            cell.back.backgroundColor = cor
            
            if ativ.tipo == 0 {
                cell.barra.hidden = false
            }
            else {
                cell.barra.hidden = true
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let vC: AddAtividadeViewController = AddAtividadeViewController()
            
            var ativ: Atividade!
            
            switch indexPath.section {
            case 0:
                ativ = atividades7Dias[indexPath.row]
            case 1:
                ativ = atividades15Dias[indexPath.row]
            case 2:
                ativ = atividades30Dias[indexPath.row]
            case 3:
                ativ = atividades30MaisDias[indexPath.row]
            default:
                break
            }
            
            vC.cancelarNotificacao(ativ.nome, materia: ativ.disciplina, data: ativ.data)
            AtividadeManager.sharedInstance.removerAtividade(ativ.id as Int)
        }
        atualiza_OrdenaVetores()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentedC.selectedSegmentIndex == 0 {
            switch indexPath.section {
            case 0:
                atividadeSelecionada = atividades7Dias[indexPath.row]
            case 1:
                atividadeSelecionada = atividades15Dias[indexPath.row]
            case 2:
                atividadeSelecionada = atividades30Dias[indexPath.row]
            case 3:
                atividadeSelecionada = atividades30MaisDias[indexPath.row]
            default:
                break
            }
        }
        else {
            atividadeSelecionada = atividadesConcluidas[indexPath.row]
        }
        
        self.performSegueWithIdentifier("detalhesView", sender: nil)
        
    }
    
    func mudarTable(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    func atualiza_OrdenaVetores() {
        atividades = AtividadeManager.sharedInstance.buscarAtividades()
        disciplinas = DisciplinaManager.sharedInstance.buscarDisciplinas()
        
        atividadesOrdenadas = atividades
        atividadesOrdenadas.sort({$0.data.timeIntervalSinceNow < $1.data.timeIntervalSinceNow })
        
        atividades7Dias = []
        atividades15Dias = []
        atividades30Dias = []
        atividades30MaisDias = []
        atividadesConcluidas = []
        
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
                            if dataCompara.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                                atividades7Dias.append(atividadesOrdenadas[i])
                            } else {
                                atividadesConcluidas.append(atividadesOrdenadas[i])
                            }
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalhesView" {
            let vC: DetalhesAtividadeViewController = segue.destinationViewController as! DetalhesAtividadeViewController
            vC.atividadeSelecionada = atividadeSelecionada
        }
    }
    
    
}
