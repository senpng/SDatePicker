import UIKit

public class SDatePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var cancelBlock: (()->())?;
    public var doneBlock: ((date: NSDate)->())?;
    public let pickerView = UIPickerView();
    
    private var _yearArray = [String]();
    private var _monthArray = [String]();
    private var _daysArray = [String]();
    private var _amPmArray = [String]();
    private var _hoursArray = [String]();
    private var _minutesArray = [String]();
    
    private var _selectedYearRow: Int = 0;
    private var _selectedMonthRow: Int = 0;
    private var _selectedDayRow: Int = 0;
    private var _selectedHourRow: Int = 0;
    private var _selectedMinutesRow: Int = 0;
    private var _selectedAMPMRow: Int = 0;
    
    init() {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 176.0));
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, frame.size.width, 34.0));
        self.addSubview(toolBar);
        
        let font = UIFont.systemFontOfSize(14.0);
        
        let doneBtn = UIBarButtonItem(title: "确定", style: .Done, target: self, action: #selector(SDatePicker.done));
        doneBtn.setTitleTextAttributes([NSFontAttributeName:font], forState: .Normal);
        let flexibleSpaceBtn = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil);
        let cancelBtn = UIBarButtonItem(title: "取消", style: .Done, target: self, action: #selector(SDatePicker.close));
        cancelBtn.setTitleTextAttributes([NSFontAttributeName:font], forState: .Normal);
        
        toolBar.items = [doneBtn, flexibleSpaceBtn, cancelBtn];
        
        let titleLabel = UILabel();
        titleLabel.text = "日期选择";
        titleLabel.font = font;
        titleLabel.sizeToFit();
        titleLabel.center = toolBar.center;
        toolBar.addSubview(titleLabel);
        
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        pickerView.frame = CGRectMake(0, toolBar.frame.size.height, frame.size.width, frame.size.height-toolBar.frame.size.height);
        pickerView.backgroundColor = UIColor.whiteColor();
        self.addSubview(pickerView);
        
        
        // PickerView -  Years data
        for i in 1970...2050 {
            _yearArray.append("\(i)");
        }
        
        // PickerView -  Months data
        for i in 1...12 {
            _monthArray.append("\(i)");
        }
        
        // PickerView -  Days data
        for i in 1...31 {
            _daysArray.append("\(i<10 ? "0":"")\(i)");
        }
        
        // PickerView -  AM PM data
        _amPmArray = ["AM","PM"];
        
        // PickerView -  Hours data
        for i in 1...12 {
            _hoursArray.append("\(i<10 ? "0":"")\(i)");
        }
        
        // PickerView -  Minutes data
        for i in 0..<60 {
            _minutesArray.append("\(i<10 ? "0":"")\(i)");
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    private var _blockView = UIView();
    
    //MARK: - Public Func
    
    public class func showInView(view: UIView, _ done: (date: NSDate) -> (), _ cancel: () -> ()) {
        
        let frame = CGRectMake(0.0, view.frame.size.height, view.frame.size.width, 176.0);
        
        let picker = SDatePicker(frame: frame);
        picker.cancelBlock = cancel;
        picker.doneBlock = done;
        
        let blockView = picker._blockView;
        blockView.backgroundColor = UIColor.blackColor();
        blockView.alpha = 0.0;
        blockView.frame = view.bounds;
        let tapG = UITapGestureRecognizer(target: picker, action: #selector(SDatePicker.close))
        tapG.numberOfTapsRequired = 1;
        blockView.addGestureRecognizer(tapG);
        
        view.addSubview(blockView);
        view.addSubview(picker);
        
        UIView.animateWithDuration(0.3, animations: {
            
            var frame = picker.frame;
            frame.origin.y = view.frame.size.height-frame.size.height;
            picker.frame = frame;
            
            blockView.alpha = 0.3;
            
        }) { (finished: Bool) in
            
            picker.pickerView.reloadAllComponents();
            picker.selectNowDate();
            
        }
        
    }
    
    /**
     私有方法，点击确定调用
     */
    @objc private func done() {
        let year = _yearArray[_selectedYearRow];
        let month = _monthArray[_selectedMonthRow];
        let day = _daysArray[_selectedDayRow];
        var hours = Int(_hoursArray[_selectedHourRow])!;
        let minutes = _minutesArray[_selectedMinutesRow];
        let amPm = _amPmArray[_selectedAMPMRow];
        
        if amPm == "PM" {
            if hours < 12 {
                hours += 12;
            }
        }else{
            if hours == 12 {
                hours = 0;
            }
        }
        
        let dateString = "\(year)-\(month)-\(day) \(hours):\(minutes)";
        
        //将时间字符串转化为NSDate
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm";
        //dateFormatter通过setTimeZone来设置正确的时区
        
        //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
        
        let date = dateFormatter.dateFromString(dateString);
        
        doneBlock?(date: date!);
        
        self.removeFromSuperview();
        _blockView.removeFromSuperview();
    }
    
    /**
     私有方法，点击取消调用，点击遮罩背景调用
     */
    @objc private func close() {
        cancelBlock?();
        self.removeFromSuperview();
        _blockView.removeFromSuperview();
    }
    
    public func selectNowDate() {
        let date = NSDate();
        
        // Get Current Year
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy";
        let currentYearString = formatter.stringFromDate(date);
        
        
        // Get Current  Month
        formatter.dateFormat = "MM";
        var currentMonthString = formatter.stringFromDate(date);
        currentMonthString = "\(Int(currentMonthString)!)"
        
        
        // Get Current  Day
        formatter.dateFormat = "dd";
        let currentDayString = formatter.stringFromDate(date);
        
        // Get Current  Hour
        formatter.dateFormat = "hh";
        var currentHourString = formatter.stringFromDate(date);
        var hour = Int(currentHourString)!;
        if (hour > 12) {
            hour-=12;
        }
        currentHourString = "\(hour < 10 ? "0":"")\(hour)";
        
        // Get Current  Minutes
        formatter.dateFormat = "mm";
        let currentMinutesString = formatter.stringFromDate(date);
        
        // Get Current  AM PM
        formatter.dateFormat = "a";
        var currentTimeAMPMString = formatter.stringFromDate(date);
        
        if currentTimeAMPMString == "上午" {
            currentTimeAMPMString = "AM";
        }else if(currentTimeAMPMString == "下午") {
            currentTimeAMPMString = "PM";
        }
        
        
        _selectedYearRow = _yearArray.indexOf(currentYearString)!;
        _selectedMonthRow = _monthArray.indexOf(currentMonthString)!;
        _selectedDayRow = _daysArray.indexOf(currentDayString)!;
        _selectedHourRow = _hoursArray.indexOf(currentHourString)!;
        _selectedMinutesRow = _minutesArray.indexOf(currentMinutesString)!;
        _selectedAMPMRow = _amPmArray.indexOf(currentTimeAMPMString)!;
        
        
        // PickerView - Default Selection as per current Date
        pickerView.selectRow(_selectedYearRow, inComponent: 0, animated: true);
        pickerView.selectRow(_selectedMonthRow, inComponent: 1, animated: true);
        pickerView.selectRow(_selectedDayRow, inComponent: 2, animated: true);
        pickerView.selectRow(_selectedHourRow, inComponent: 3, animated: true);
        pickerView.selectRow(_selectedMinutesRow, inComponent: 4, animated: true);
        pickerView.selectRow(_selectedAMPMRow, inComponent: 5, animated: true);
    }
    
    //MARK: - UIPickerViewDelegate
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            _selectedYearRow = row;
            
        case 1:
            _selectedMonthRow = row;
            
        case 2:
            _selectedDayRow = row;
            
        case 3:
            _selectedHourRow = row;
            
        case 4:
            _selectedMinutesRow = row;

        case 5:
            _selectedAMPMRow = row;
            
        default:
            break;
        }
        
         pickerView.reloadAllComponents();
    }
    
    //MARK: - UIPickerViewDataSource
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 6;
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0;
        
        switch component {
        case 0:
            count = _yearArray.count;
            
        case 1:
            count = _monthArray.count;
            
        case 2:
            
            let currentMonth = Int(_monthArray[_selectedMonthRow]);
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                count = 31;
            }
            else if (currentMonth == 2)
            {
                let currentYear = Int(_yearArray[_selectedYearRow])!;
                
                if(((currentYear%4 == 0)&&(currentYear%100 != 0))||(currentYear%400 == 0)){
                    
                    count = 29;
                }
                else
                {
                    count = 28;
                }
                
            }
            else
            {
                count = 30;
            }
            
            
        case 3:
            return _hoursArray.count;
            
        case 4:
            return _minutesArray.count;
            
        case 5:
            return _amPmArray.count;
            
        default:
            break;
        }
        
        return count;
    }
    
    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel: UILabel!;
        
        if let label = view as? UILabel {
            pickerLabel = label;
        } else {
            pickerLabel = UILabel();
        }
        
        pickerLabel.textAlignment = .Center;
        pickerLabel.backgroundColor = UIColor.clearColor();
        pickerLabel.font = UIFont.systemFontOfSize(15.0);
        
        var str: String?;
        
        switch component {
        case 0:
            str = _yearArray[row];
            
        case 1:
            str = _monthArray[row];
            
        case 2:
            str = _daysArray[row];
            
        case 3:
            str = _hoursArray[row];
            
        case 4:
            str = _minutesArray[row];
            
        case 5:
            str = _amPmArray[row];
            
        default:
            break;
        }
        
        pickerLabel.text = str;

        
        return pickerLabel;
    }
    
//    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        var str: String?;
//        
//        switch component {
//        case 0:
//            str = _yearArray[row];
//            
//        case 1:
//            str = _monthArray[row];
//            
//        case 2:
//            str = _daysArray[row];
//            
//        case 3:
//            str = _hoursArray[row];
//            
//        case 4:
//            str = _minutesArray[row];
//            
//        case 5:
//            str = _amPmArray[row];
//            
//        default:
//            break;
//        }
//        
//        return str;
//    }
}

