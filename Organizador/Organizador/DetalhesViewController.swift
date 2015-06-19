//
//  DetalhesViewController.swift
//  Organizador
//
//  Created by Vivian Dias on 18/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class DetalhesViewController: UITableViewController {
    
    let vC: ProvasViewController = ProvasViewController()
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var materiaTxt: UITextField!
    @IBOutlet weak var notaTxt: UITextField!
    @IBOutlet weak var pesoTxt: UITextField!
    @IBOutlet weak var dataTxt: UITextField!
    @IBOutlet weak var obsTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2:
            return 3
        default: return 0
        }
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
