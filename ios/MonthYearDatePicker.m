#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(MonthYearDatePicker, RCTEventEmitter)

RCT_EXTERN_METHOD(showPicker)

@end

@implementation MonthYearDatePicker {
  NSArray<NSString *> *months;
  NSArray<NSNumber *> *years;
  UIPickerView *picker;
  UIAlertController *alert;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    NSMutableArray *yearsArray = [NSMutableArray array];
    for (int year = 1900; year <= 2100; year++) {
      [yearsArray addObject:@(year)];
    }
    years = [yearsArray copy];
  }
  return self;
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
  return @[@"onDateSelected"];
}

RCT_EXPORT_METHOD(showPicker) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewController) return;

    alert = [UIAlertController alertControllerWithTitle:@"Select Month & Year"
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];

    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, rootViewController.view.frame.size.width, 300)];
    picker.delegate = self;
    picker.dataSource = self;

    [alert.view addSubview:picker];

    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      NSInteger selectedMonth = [self->picker selectedRowInComponent:0];
      NSInteger selectedYear = [self->picker selectedRowInComponent:1];
      NSString *selectedMonthName = self->months[selectedMonth];
      NSNumber *selectedYearNumber = self->years[selectedYear];

      [self sendEventWithName:@"onDateSelected" body:@{@"month": selectedMonthName, @"year": selectedYearNumber}];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:doneAction];
    [alert addAction:cancelAction];

    [rootViewController presentViewController:alert animated:YES completion:nil];
  });
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 2; // One for month and one for year
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return component == 0 ? months.count : years.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return component == 0 ? months[row] : [years[row] stringValue];
}

@end