//
//  AddMateriaViewController.swift
//  Organizador
//
//  Created by Vivian Dias on 14/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class AddMateriaViewController: UITableViewController {

    
    @IBOutlet weak var txtNome: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    @IBAction func salvar(sender: AnyObject) {
        
     //   DisciplinaManager.sharedInstance.salvarNovaDisciplina(txtNome.text, cor: <#String#>)
        
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
