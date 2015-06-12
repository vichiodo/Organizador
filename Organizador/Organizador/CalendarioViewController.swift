//
//  CalendarioViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 06/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit
import EventKit

class CalendarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var atividadeTextField: UITextField!
    @IBOutlet weak var calendario: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        calendario.minimumDate = NSDate()

        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        return cell
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func salvarEvento(sender: AnyObject) {
        
        calendario.datePickerMode = UIDatePickerMode.Date
        
        let date = NSDate()
                
        calendario.minimumDate = date

        var eventStore: EKEventStore = EKEventStore()
        
        var evento: EKEvent = EKEvent(eventStore: eventStore)
        
        evento.title = atividadeTextField.text
        
        evento.startDate = calendario.date
        
        evento.endDate = NSDate(timeInterval: 600, sinceDate: evento.startDate)
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error NSError) -> Void in
            if !granted {
                return
            }else {
                evento.calendar = eventStore.defaultCalendarForNewEvents
                
                eventStore.saveEvent(evento, span: EKSpanThisEvent, commit: true, error: NSErrorPointer())
            }
        })
        
        atividadeTextField.text = " "
        
    }
    
}
