//
//  SDatePicker.m
//  BKDateAndTimePickerView
//
//  Created by 沈鹏 on 14/10/24.
//  Copyright (c) 2014年 Bhavya Kothari. All rights reserved.
//

#import "SDatePicker.h"
#define currentMonth [currentMonthString integerValue]

@interface SDatePicker()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    Done d;
    Cancel c;
    UIView *blockView;
    BOOL firstTimeLoad;
}


@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;

@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;

#pragma mark - IBActions

- (IBAction)actionCancel:(id)sender;

- (IBAction)actionDone:(id)sender;

@end

@implementation SDatePicker
{
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSArray *amPmArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    //    BOOL firstTimeLoad;
    
}

-(id)init
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SDatePicker class]) owner:self options:nil][0];
    if (self) {
        firstTimeLoad = YES;
        
        self.customPicker.delegate = self;
        self.customPicker.dataSource = self;
        
        NSDate *date = [NSDate date];
        
        // Get Current Year
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        
        NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                       [formatter stringFromDate:date]];
        
        
        // Get Current  Month
        
        [formatter setDateFormat:@"MM"];
        
        currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
        
        
        // Get Current  Date
        
        [formatter setDateFormat:@"dd"];
        NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        
        // Get Current  Hour
        [formatter setDateFormat:@"hh"];
        NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        NSInteger hour = [currentHourString intValue];
        if (hour>12) {
            hour-=12;
        }
        currentHourString = [NSString stringWithFormat:@"%02d",hour];
        
        // Get Current  Minutes
        [formatter setDateFormat:@"mm"];
        NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        // Get Current  AM PM
        
        [formatter setDateFormat:@"a"];
        NSString *currentTimeAMPMString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        if ([currentTimeAMPMString isEqualToString:@"上午"]) {
            currentTimeAMPMString = @"AM";
        }else if([currentTimeAMPMString isEqualToString:@"下午"]){
            currentTimeAMPMString = @"PM";
        }
        
        
        // PickerView -  Years data
        
        yearArray = [[NSMutableArray alloc]init];
        
        
        for (int i = 1970; i <= 2050 ; i++)
        {
            [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
        
        
        // PickerView -  Months data
        
        
        monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        
        
        // PickerView -  Hours data
        
        
        hoursArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
        
        
        // PickerView -  Hours data
        
        minutesArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < 60; i++)
        {
            
            [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
            
        }
        
        
        // PickerView -  AM PM data
        
        amPmArray = @[@"AM",@"PM"];
        
        
        
        // PickerView -  days data
        
        DaysArray = [[NSMutableArray alloc]init];
        
        for (int i = 1; i <= 31; i++)
        {
            [DaysArray addObject:[NSString stringWithFormat:@"%02d",i]];
            
        }
        
        
        // PickerView - Default Selection as per current Date
        
        [self.customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
        
        [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
        
        [self.customPicker selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
        
        [self.customPicker selectRow:[hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
        
        [self.customPicker selectRow:[minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
        
        [self.customPicker selectRow:[amPmArray indexOfObject:currentTimeAMPMString] inComponent:5 animated:YES];
        
        
    }
    return self;
}

#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self.customPicker reloadAllComponents];
        
    }
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    else if (component == 3)
    {
        pickerLabel.text =  [hoursArray objectAtIndex:row]; // Hours
    }
    else if (component == 4)
    {
        pickerLabel.text =  [minutesArray objectAtIndex:row]; // Mins
    }
    else
    {
        pickerLabel.text =  [amPmArray objectAtIndex:row]; // AM/PM
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 6;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    { // day
        
        if (firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        else
        {
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
                
                
            }
            else
            {
                return 30;
            }
            
        }
        
        
    }
    else if (component == 3)
    { // hour
        
        return 12;
        
    }
    else if (component == 4)
    { // min
        return 60;
    }
    else
    { // am/pm
        return 2;
        
    }
    
    
    
}

- (IBAction)actionCancel:(id)sender
{
    c();
    [self hidden];
}

- (IBAction)actionDone:(id)sender
{
    
    NSInteger year = [[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]] integerValue];
    NSInteger month = [[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]] integerValue];
    NSInteger day = [[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]] integerValue];
    NSInteger hours = [[hoursArray objectAtIndex:[self.customPicker selectedRowInComponent:3]] integerValue];
    NSInteger minutes = [[minutesArray objectAtIndex:[self.customPicker selectedRowInComponent:4]] integerValue];
    NSString *amPm = [amPmArray objectAtIndex:[self.customPicker selectedRowInComponent:5]];
    
    NSString *dateString;
    
    if ([amPm isEqualToString:@"PM"]) {
        if (hours<12) {
            hours+=12;
        }
    }else{
        if (hours==12) {
            hours=0;
        }
    }
    
    dateString = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",year,month,day,hours,minutes];
    
    //将时间字符串转化为NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    //dateFormatter通过setTimeZone来设置正确的时区
    
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    
    NSDate *date=[dateFormatter dateFromString:dateString];
    
    
    d(date);
    [self hidden];
}

-(void)hidden
{
    [UIView animateWithDuration:0.3f
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.x = 0;
                         frame.origin.y +=frame.size.height;
                         [self setFrame:frame];
                         
                     }
                     completion:^(BOOL finished){
                         [blockView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

-(void)tapBlockView
{
    [self actionCancel:nil];
}

+(void)showInView:(UIView *)view Done:(Done)done Cancel:(Cancel)cancel
{
    SDatePicker *sdPicker = [SDatePicker new];
    sdPicker->c = cancel;
    sdPicker->d = done;
    
    CGRect frame = sdPicker.frame;
    frame.origin.x = 0;
    frame.origin.y = view.frame.size.height;
    [sdPicker setFrame:frame];
    
    //遮挡层
    sdPicker->blockView = [[UIView alloc] initWithFrame:view.frame];
    sdPicker->blockView.backgroundColor = [UIColor blackColor];
    sdPicker->blockView.alpha = 0.3f;
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:sdPicker action:@selector(tapBlockView)];
    [touch setNumberOfTapsRequired:1];
    [sdPicker->blockView addGestureRecognizer:touch];
    
    [view addSubview:sdPicker->blockView];
    [view addSubview:sdPicker];
    
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect frame = sdPicker.frame;
                         frame.origin.x = 0;
                         frame.origin.y = view.frame.size.height-frame.size.height;
                         [sdPicker setFrame:frame];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

@end
