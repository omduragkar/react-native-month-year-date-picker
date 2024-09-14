#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(MonthYearDatePicker, NSObject)
RCT_EXTERN_METHOD(showPicker:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(setPicker:(NSInteger)month year:(NSInteger)year)
RCT_EXTERN_METHOD(getSelectedValues:(RCTResponseSenderBlock)callback)
@end

@implementation MonthYearDatePicker {
  NSArray<NSString *> *months;
  NSArray<NSNumber *> *years;
  UIPickerView *picker;
  UIViewController *pickerViewController;
  RCTResponseSenderBlock callback;
  NSInteger defaultMonth;
  NSInteger defaultYear;
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
    defaultMonth = -1;
    defaultYear = -1;
  }
  return self;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(showPicker:(RCTResponseSenderBlock)callback) {
  dispatch_async(dispatch_get_main_queue(), ^{
    self->callback = callback;
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewController) return;

    self->pickerViewController = [[UIViewController alloc] init];
    self->pickerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self->pickerViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    UIView *pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, rootViewController.view.frame.size.height - 260, rootViewController.view.frame.size.width, 260)];
    pickerContainer.backgroundColor = [UIColor systemBackgroundColor]; // Adapts to light/dark mode

    self->picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, pickerContainer.frame.size.width, 216)];
    self->picker.delegate = self;
    self->picker.dataSource = self;

    // Set default selection to current month and year if not set
    if (self->defaultMonth == -1 || self->defaultYear == -1) {
      NSDate *currentDate = [NSDate date];
      NSCalendar *calendar = [NSCalendar currentCalendar];
      NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:currentDate];
      self->defaultMonth = [components month]; // 1-indexed
      self->defaultYear = [components year];
    }

    NSInteger monthIndex = self->defaultMonth - 1; // Convert to 0-indexed
    NSInteger yearIndex = [self->years indexOfObject:@(self->defaultYear)];
    if (monthIndex >= 0 && monthIndex < self->months.count && yearIndex != NSNotFound) {
      [self->picker selectRow:monthIndex inComponent:0 animated:NO];
      [self->picker selectRow:yearIndex inComponent:1 animated:NO];
    }

    [pickerContainer addSubview:self->picker];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(pickerContainer.frame.size.width - 70, 5, 60, 30);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal]; // Adapts to light/dark mode
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(10, 5, 60, 30);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal]; // Adapts to light/dark mode
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [pickerContainer addSubview:doneButton];
    [pickerContainer addSubview:cancelButton];

    [self->pickerViewController.view addSubview:pickerContainer];

    // Adjust colors for dark mode
    if (@available(iOS 13.0, *)) {
      self->pickerViewController.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
      self->picker.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }
    [rootViewController presentViewController:self->pickerViewController animated:YES completion:nil];

  });
}

RCT_EXPORT_METHOD(setPicker:(NSInteger)month year:(NSInteger)year) {
  dispatch_async(dispatch_get_main_queue(), ^{
    self->defaultMonth = month;
    self->defaultYear = year;
  });
}

RCT_EXPORT_METHOD(getPickerValue:(RCTResponseSenderBlock)callback) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->defaultMonth != -1 && self->defaultYear != -1) {
      NSString *selectedMonthName = self->months[self->defaultMonth - 1]; // Convert to 0-indexed
      NSNumber *selectedYearNumber = @(self->defaultYear);
      callback(@[@{@"monthName": selectedMonthName, @"monthNumber": @(self->defaultMonth), @"year": selectedYearNumber}]);
    } else {
      NSInteger selectedMonth = [self->picker selectedRowInComponent:0];
      NSInteger selectedYear = [self->picker selectedRowInComponent:1];
      NSString *selectedMonthName = self->months[selectedMonth];
      NSNumber *selectedYearNumber = self->years[selectedYear];
      callback(@[@{@"monthName": selectedMonthName, @"monthNumber": @(selectedMonth + 1), @"year": selectedYearNumber}]);
    }
  });
}

- (void)doneButtonPressed {
  NSInteger selectedMonth = [self->picker selectedRowInComponent:0];
  NSInteger selectedYear = [self->picker selectedRowInComponent:1];
  NSString *selectedMonthName = self->months[selectedMonth];
  NSNumber *selectedYearNumber = self->years[selectedYear];

  self->defaultMonth = selectedMonth + 1; // Convert to 1-indexed
  self->defaultYear = [selectedYearNumber integerValue];

  if (self->callback) {
    self->callback(@[@{@"monthName": selectedMonthName, @"monthNumber": @(selectedMonth + 1), @"year": selectedYearNumber}]);
  }

  [self->pickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonPressed {
  [self->pickerViewController dismissViewControllerAnimated:YES completion:nil];
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