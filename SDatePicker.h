//
//  SDatePicker.h
//  BKDateAndTimePickerView
//
//  Created by 沈鹏 on 14/10/24.
//  Copyright (c) 2014年 Bhavya Kothari. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Done)(NSDate *date);
typedef void(^Cancel)();

@interface SDatePicker : UIView

+(void)showInView:(UIView*)view Done:(Done)done Cancel:(Cancel)cancel;

@end
