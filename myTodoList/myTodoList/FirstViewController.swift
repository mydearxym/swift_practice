//
//  FirstViewController.swift
//  myTodoList
//
//  Created by mydear-xym on 14-9-16.
//  Copyright (c) 2014年 xieyiming. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tblTasks: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returning to view
    override func viewWillAppear(animated: Bool) {
        tblTasks.reloadData()
    }
    
    // TableView Delete func
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if ( editingStyle == UITableViewCellEditingStyle.Delete) {
            taskMgr.tasks.removeAtIndex(indexPath.row)
            tblTasks.reloadData()
        }
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskMgr.tasks.count
    }

    // 执行 taskMgr.tasks.count 次
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")

       // For the main text use cell.textLabel.text = ...;
       //For the subtext use cell.detailTextLabel.text = ...;
        cell.textLabel?.text = taskMgr.tasks[indexPath.row].name
        cell.detailTextLabel?.text = taskMgr.tasks[indexPath.row].desc
        return cell
    }

}

