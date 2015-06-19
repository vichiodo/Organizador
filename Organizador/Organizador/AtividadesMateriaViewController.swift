//
//  AtividadesMateriaViewController.swift
//  Organizador
//
//  Created by Ricardo Hochman on 19/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class AtividadesMateriaViewController: UIViewController {
    
    var discliplinaSelecionada: Disciplina!
    var atividadesDisciplinaSelecionada: [Atividade]!
    
    @IBOutlet weak var tableView: UITableView!
    var atividadeSelecionada: Atividade!
    
    lazy var atividades:Array<Atividade> = {
        return AtividadeManager.sharedInstance.buscarAtividades()
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Registra o xib da Célula
        var nibP : UINib = UINib(nibName: "CellProva", bundle: nil);
        tableView.registerNib(nibP, forCellReuseIdentifier: "CellProva");
        var nibT : UINib = UINib(nibName: "CellTarefa", bundle: nil);
        tableView.registerNib(nibT, forCellReuseIdentifier: "CellTarefa");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = discliplinaSelecionada.nome
        atividades = AtividadeManager.sharedInstance.buscarAtividades()
        
        
        var atividadesOrdenadas = atividades
        atividadesOrdenadas.sort({$0.data.timeIntervalSinceNow < $1.data.timeIntervalSinceNow })
        
        atividadesDisciplinaSelecionada = []

        if atividadesOrdenadas.count != 0 {
            for i in 0...atividadesOrdenadas.count - 1 {
                if atividadesOrdenadas[i].disciplina == discliplinaSelecionada {
                    atividadesDisciplinaSelecionada.append(atividadesOrdenadas[i])
                }
            }
            println(atividadesDisciplinaSelecionada)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return atividadesDisciplinaSelecionada.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var ativ: Atividade!
        ativ = atividadesDisciplinaSelecionada[indexPath.row]
        
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        atividadeSelecionada = atividadesDisciplinaSelecionada[indexPath.row]
        self.performSegueWithIdentifier("showDetalheMat", sender: nil)
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
        if segue.identifier == "showDetalheMat" {
            let vC: DetalhesViewController = segue.destinationViewController as! DetalhesViewController
            vC.atividadeSelecionada = atividadeSelecionada
        }
    }
    
}
