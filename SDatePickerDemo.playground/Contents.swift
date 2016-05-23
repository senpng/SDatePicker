//: Playground - noun: a place where people can play

import UIKit

import XCPlayground

let currentPage = XCPlaygroundPage.currentPage;

class ViewController: UIViewController {
    override func loadView() {
        view = UIView(frame: CGRectMake(0,0,320,568))
        view.backgroundColor = UIColor.whiteColor();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        SDatePicker.showInView(view, { (date) in
            print(date);
        }) {
            print("cancel");
        };
    }
}

let vc = ViewController();

let view = vc.view;


currentPage.liveView = vc.view;
