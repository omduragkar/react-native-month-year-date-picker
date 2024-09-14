import { UIManager, Platform, NativeModules } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-month-year-date-picker' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ComponentName = 'MonthYearDatePickerView';
const { MonthYearDatePicker } = NativeModules;
export const MonthYearDatePickerView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? MonthYearDatePicker
    : () => {
        throw new Error(LINKING_ERROR);
      };
