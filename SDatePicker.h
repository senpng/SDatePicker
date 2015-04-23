
#import <UIKit/UIKit.h>

typedef void(^Done)(NSDate *date);
typedef void(^Cancel)();

@interface SDatePicker : UIView

+(void)showInView:(UIView*)view Done:(Done)done Cancel:(Cancel)cancel;

@end
