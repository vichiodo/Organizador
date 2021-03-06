//
//  AddMateriaViewController.swift
//  Organizador
//
//  Created by Vivian Dias on 14/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class AddMateriaViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var arrayCores = ["CF000F", "D2527F", "663399", "22A7F0", "00B16A", "F9690E", "F7CA18", "BFBFBF", "000000", "8B4513"]
    var corSelecionada: String = ""
    var indexOld: Int = 0
    var disciplinaSelecionada: Disciplina?
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var coresCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        if disciplinaSelecionada != nil {
            txtNome.text = disciplinaSelecionada!.nome
            corSelecionada = disciplinaSelecionada!.cor
            for i in 0...arrayCores.count - 1 {
                if disciplinaSelecionada!.cor == arrayCores[i] {
                    var path: NSIndexPath = NSIndexPath(forItem: i, inSection: 0)
                    self.coresCollectionView.selectItemAtIndexPath(path, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)

                    var datasetCell2: UICollectionViewCell = coresCollectionView.cellForItemAtIndexPath(path)!
                    datasetCell2.contentView.layer.borderWidth = 3.0
                    datasetCell2.contentView.layer.borderColor = atualizaCorBorda(self.stringParaCor(arrayCores[path.row])).CGColor
                }
            }
        }
        
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
        cell.contentView.layer.cornerRadius = cell.contentView.frame.size.width * 0.2
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != indexOld {
            var path: NSIndexPath = NSIndexPath(forItem: indexOld, inSection: 0)
            
            var datasetCell: UICollectionViewCell = coresCollectionView.cellForItemAtIndexPath(path)!
            datasetCell.contentView.layer.borderWidth = 0.0
            datasetCell.contentView.layer.borderColor = atualizaCorBorda(self.stringParaCor(arrayCores[indexPath.row])).CGColor
            
            var datasetCell2: UICollectionViewCell = coresCollectionView.cellForItemAtIndexPath(indexPath)!
            datasetCell2.contentView.layer.borderWidth = 3.0
            datasetCell2.contentView.layer.borderColor = atualizaCorBorda(self.stringParaCor(arrayCores[indexPath.row])).CGColor
            
            indexOld = indexPath.row
        }
        else {
            var datasetCell2: UICollectionViewCell = coresCollectionView.cellForItemAtIndexPath(indexPath)!
            datasetCell2.contentView.layer.borderWidth = 3.0
            datasetCell2.contentView.layer.borderColor = atualizaCorBorda(self.stringParaCor(arrayCores[indexPath.row])).CGColor
        }
        
        corSelecionada = arrayCores[indexPath.row]
    }
    
    func atualizaCorBorda(cor: UIColor) -> UIColor {
        let componentColors = CGColorGetComponents(cor.CGColor)
        var colorBrightness: CGFloat = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000
        var returnColor: UIColor
        if colorBrightness < 0.5 {
            returnColor = UIColor.lightGrayColor()
        }
        else {
            returnColor = UIColor.blackColor()
        }
        return returnColor
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
                if disciplinaSelecionada != nil {
                    disciplinaSelecionada!.nome = txtNome.text
                    disciplinaSelecionada!.cor = corSelecionada
                    DisciplinaManager.sharedInstance.salvarDisciplina()
                } else {
                    DisciplinaManager.sharedInstance.salvarNovaDisciplina(txtNome.text, cor: corSelecionada)
                }
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
