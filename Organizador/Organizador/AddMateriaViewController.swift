//
//  AddMateriaViewController.swift
//  Organizador
//
//  Created by Vivian Dias on 14/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class AddMateriaViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var arrayCores = ["CF000F", "D2527F", "663399", "22A7F0", "00B16A", "F9690E", "F7CA18", "BFBFBF"]
    var corSelecionada: String = ""
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var coresCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.coresCollectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "corCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        default: return 0
        }
    }
    
    // MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCores.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("corCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        // background de acordo com a label
        cell.contentView.backgroundColor = self.stringParaCor(arrayCores[indexPath.row])
        cell.contentView.layer.cornerRadius = cell.contentView.frame.size.width / 2
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        corSelecionada = arrayCores[indexPath.row]
        println("\(corSelecionada)")
        
        var datasetCell: UICollectionViewCell = coresCollectionView.cellForItemAtIndexPath(indexPath)!
        datasetCell.backgroundColor = UIColor.blackColor()
        datasetCell.contentView.layer.cornerRadius = datasetCell.contentView.frame.size.width / 2
        datasetCell.contentView.clipsToBounds = true
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
    
    @IBAction func salvar(sender: AnyObject) {
        if txtNome.text == "" {
            let alerta: UIAlertController = UIAlertController(title: "Digite o nome da matéria", message: nil, preferredStyle: .Alert)
            let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                txtNome.becomeFirstResponder()
            })
            [alerta.addAction(al1)]
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else {
            if corSelecionada == "" {
                let alerta: UIAlertController = UIAlertController(title: "Escolha uma cor", message: nil, preferredStyle: .Alert)
                let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                })
                [alerta.addAction(al1)]
                self.presentViewController(alerta, animated: true, completion: nil)
            }
            else {
                DisciplinaManager.sharedInstance.salvarNovaDisciplina(txtNome.text, cor: corSelecionada)
                println("matéria salva")
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
