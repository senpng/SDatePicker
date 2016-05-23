//
//  ViewController.swift
//  SDatePickerDemo
//
//  Created by 沈鹏 on 16/5/23.
//  Copyright © 2016年 沈鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(sender: AnyObject) {
        SDatePicker.showInView(self.view, { (date) in
            print(date);
            }) { 
            print("cancel");
        };
    }

}

