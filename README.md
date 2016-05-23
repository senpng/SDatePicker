# SDatePicker

可以使用CocoaPods安装

    pod "SDatePicker"

日期时间Picker。

public class func showInView(view: UIView, _ done: (date: NSDate) -> (), _ cancel: () -> ());

Example：

	SDatePicker.showInView(self.view, { (date) in
            print(date);
            }) { 
            print("cancel");
        };

图片：
	 ![image](https://github.com/SenPng/SDatePicker/raw/master/Example.jpg)

如有问题。请反馈给我。谢谢：senpng@qq.com