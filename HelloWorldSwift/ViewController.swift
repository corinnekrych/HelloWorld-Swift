//
//  ViewController.swift
//  HelloWorldSwift
//
//  Created by Corinne Krych on 12/06/14.
//  Copyright (c) 2014 aerogear. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
                            
    @IBOutlet var tableView : UITableView
    var messages: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messages = ["Registering...."]
        
        // func addObserver(observer: AnyObject!, selector aSelector: Selector, name aName: String!, object anObject: AnyObject!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "registered", name: "success_registered", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "errorRegistration", name: "error_register", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "message_received", object: nil)
        
        
        var date = NSDateComponents()
        date.year = 2014
        date.month = 06
        date.day = 20
        date.hour = 14
        date.minute = 27
        
        date.timeZone = NSTimeZone.systemTimeZone()
        
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var myDate = calendar.dateFromComponents(date)

        let localNotification1 = UILocalNotification()
        localNotification1.fireDate = myDate
        localNotification1.category = "HelloWorld"
        localNotification1.alertBody = "Ping!"
        localNotification1.repeatInterval = NSCalendarUnit.SecondCalendarUnit
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registered() {
        NSLog("registered");
        messages.removeAtIndex(0)
        messages.append("Sucessfully registered")
        // workaround to get messages when app was not running
        //let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        //let msg : String! = defaults.objectForKey("message_received") as String
        //defaults.removeObjectForKey("message_received")
        //defaults.synchronize()
    
        //if(msg) {
        //    messages.append(msg)
        //}
        tableView.reloadData()
    }

    func errorRegistration() {
        messages.removeAtIndex(0)
        messages.append("Error during registration")
        tableView.reloadData()
    }
    
    func messageReceived(notification: NSNotification) {
        NSLog("received");
        // trying to access notification.object["aps"]["alert"] make Xcode6beta goes crazy (lost colouring) and eventually crash
        let msg = notification.object as NSDictionary
        let msg2 = msg["aps"] as NSDictionary
        let msg3 = msg2["alert"] as String
        messages.append(msg3)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: "Cell")
        }
        cell.textLabel.text = messages[indexPath.row]
        return cell
    }

}

