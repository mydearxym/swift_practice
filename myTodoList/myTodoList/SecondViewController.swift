//
//  SecondViewController.swift
//  myTodoList
//
//  Created by mydear-xym on 14-9-16.
//  Copyright (c) 2014年 xieyiming. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var txtTask: UITextField!
    @IBOutlet var textDesc: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Events
    @IBAction func btnAddTaskClick(sender: UIButton){
        taskMgr.addTask(txtTask.text, desc: textDesc.text)
        self.view.endEditing(true)
        txtTask.text = ""
        textDesc.text = ""
        // back to first tab
        self.tabBarController?.selectedIndex = 0
    }
    
    // 点击屏幕的任一点输入框消失
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    //UItefield delegate
    // 按了输入中的 return 输入框会消失
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //TODO: resign First Responder 什么意思？
        textField.resignFirstResponder()
        return true
    }
}

