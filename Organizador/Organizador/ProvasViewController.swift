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
    var atividadesConcluidas: Array<Atividade> = []
    var txtField: UITextField?

    
    // carrega o vetor de atividades cadastradas no CoreData
    lazy var materias:Array<Disciplina> = {
        return DisciplinaManager.sharedInstance.buscarDisciplinas()
        }()
    
    lazy var atividades:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarAtividades()
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
        
        //        var ativi: Array<Atividade>!
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
            var cell: UITableViewCell!
            
            if ativ.tipo == 0 {
                let cell: CellProva = tableView.dequeueReusableCellWithIdentifier("CellProva", forIndexPath: indexPath) as! CellProva
                
                cell.title.text = ativ.nome
                cell.date.textColor = stringParaCor(ativ.disciplina.cor)
                cell.date.text = "\(diaAtividade) \(mesString)"
                cell.matIcon.text = ativ.disciplina.nome
                cell.barra.backgroundColor = stringParaCor(ativ.disciplina.cor)
                return cell
            }
            else {
                let cell: CellTarefa = tableView.dequeueReusableCellWithIdentifier("CellTarefa", forIndexPath: indexPath) as! CellTarefa
                
                cell.title.text = ativ.nome
                cell.date.text = "\(diaAtividade)\n\(mesString)"
                cell.date.textColor = stringParaCor(ativ.disciplina.cor)
                cell.matIcon.text = ativ.disciplina.nome
                cell.barra.backgroundColor = stringParaCor(ativ.disciplina.cor)
                return cell
            }
        } else {
            let cell: CellTarefa = tableView.dequeueReusableCellWithIdentifier("CellTarefa", forIndexPath: indexPath) as! CellTarefa
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

            cell.title.text = ativ.nome
            cell.date.text = "\(diaAtividade)\n\(mesString)"
            cell.date.textColor = stringParaCor(ativ.disciplina.cor)
            cell.matIcon.text = ativ.disciplina.nome
            cell.barra.backgroundColor = stringParaCor(ativ.disciplina.cor)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let vC: AddProvaViewController = AddProvaViewController()
            
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
    
    //    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    //        let done = UITableViewRowAction(style: .Normal, title: "✅") { action, index in
    //            println("finalizada")
    //        }
    //        done.backgroundColor = UIColor.greenColor()
    //
    //        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Apagar") { (action, indexPath) -> Void in
    //
    //        }
    //
    //        return [deleteAction, done]
    //    }
    
    
    
    
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var atividade: Atividade = AtividadeManager.sharedInstance.buscarAtividade(atividades[indexPath.row].id as Int)
//        
//        
////        if segmentedC.selectedSegmentIndex == 1 {
////            let alerta: UIAlertController = UIAlertController(title: "Nota da atividade", message: nil, preferredStyle: .Alert)
////            alerta.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
////                textField.placeholder = "Nota"
////                self.txtField = textField
////            }
////            let salvar:UIAlertAction = UIAlertAction(title: "Salvar", style: .Default, handler: { (ACTION) -> Void in
////                atividade.nota = NSNumber(integer: self.txtField!.text.toInt()!)
////                
////                AtividadeManager.sharedInstance.salvarAtividade()
////
////            })
////            let cancelar:UIAlertAction = UIAlertAction(title: "Cancelar", style: .Default, handler: nil)
////            
////            [alerta.addAction(cancelar)]
////            [alerta.addAction(salvar)]
////            
////            self.presentViewController(alerta, animated: true, completion: nil)
////        }
//    }
    
    
    
    
    
    func mudarTable(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    func atualiza_OrdenaVetores() {
        atividades = AtividadeManager.sharedInstance.buscarAtividades()
        
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
