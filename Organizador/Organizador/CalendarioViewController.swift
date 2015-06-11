//
//  CalendarioViewController.swift
//  Organizador
//
//  Created by Vivian Chiodo Dias on 06/06/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import UIKit

class CalendarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var date: NSDate!
    var cal: NSCalendar!
    var monthInt: Int!
    var weekD: Int = 0
    var cont: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date = NSDate()
        
        var month = NSDateFormatter()
        month.dateFormat = "MM"
        var monthString = month.stringFromDate(date)
        monthInt = monthString.toInt()
        
        println("Mês: \(monthString)")
        println("Mês: \(monthInt)")
        
        cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        println("\(cal.weekdaySymbols)")
        
        let componentes = cal.components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        var week = componentes.weekday
        println("Semana: \(week)")
        
        var day = NSDateFormatter()
        day.dateFormat = "dd"
        var dayString = day.stringFromDate(date)
        var dayInt = dayString.toInt()
        println("\(dayInt)")
        
        if cont == 0 {
            makeCalendar(week, day: dayInt!)
        } else {
            makeCalendar(weekD, day: 1)
        }
        
        cont++
        println("Semanaaaa: \(weekD)")
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
    
    func makeCalendar(week: Int, day: Int) {
        var weekDay = week
        var dayInt = day
        var x = 58
        var y = 140
        
        weekD = week
        println("WEEKDAY: \(weekD * 45)")
        x = (45 * weekD)
        println("MI: \(monthInt)")
        for (var j: Int = 1; j < 5; j++) {
            for (var i: Int = weekDay; i <= 7; i++) {
                
                println("\(x)")
                if j == 4 {
                    var aux = dayInt
                    if monthInt == 1 || monthInt == 3 || monthInt == 5 || monthInt == 7 || monthInt == 8 || monthInt == 10 || monthInt == 12 {
                        
                        if aux == 32 {
                            return
                        }
                    }
                    else if monthInt == 4 || monthInt == 6 || monthInt == 9 || monthInt == 11 {
                        
                        if aux == 31 {
                            return
                        }
                    }else if (monthInt! == 2 && monthInt! % 4 == 0 && monthInt! % 100 == 0 && monthInt! % 400 == 0){
                        
                        if aux == 30 {
                            return
                        }
                    } else if aux == 29 {
                        return
                    }
                }
                println("\(weekD)")
                weekD++
                
                var btn: UIButton = UIButton()
                btn.setTitle("\(dayInt)", forState: UIControlState.Normal)
                btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                btn.frame = CGRect(x: x, y: y, width: 30, height: 30)
                btn.backgroundRectForBounds(btn.frame)
                btn.tag = dayInt
                btn.addTarget(self, action: "detail:", forControlEvents: .TouchUpInside)
                x = x + 40
                self.view.addSubview(btn)
                
                dayInt = dayInt + 1
            }
            if j == 0 {
                println("W: \(week)")
                var w = week
                
                if dayInt != 1 {
                    var aux = dayInt - 1
                    x = x - 40
                    
                    for (var k: Int = aux; k >= 1; k--){
                        for (var i: Int = w; i >= 1; i--){
                            
                        }
                        var btn: UIButton = UIButton()
                        btn.setTitle("\(aux)", forState: UIControlState.Normal)
                        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                        btn.frame = CGRect(x: x, y: y, width: 30, height: 30)
                        btn.tag = aux
                        btn.addTarget(self, action: "detail:", forControlEvents: .TouchUpInside)
                        x = x - 40
                        self.view.addSubview(btn)
                        
                        aux = aux - 1
                        
                    }
                }
            }
            weekD = 1
            weekDay = 1
            x = 58
            y = y + 40
            
        }
        
    }
    
    
}
