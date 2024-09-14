import { UIManager, Platform } from 'react-native';
import { NativeModules } from 'react-native';
const { MonthYearDatePicker } = NativeModules;
export type IMonthYearPickerType = {
  monthName: string;
  monthNumber: number;
  year: number;
};
export interface IMonthYearPickerProps {
  onDateChange: (result: IMonthYearPickerType) => void;
  value?: string;
  isOpen: boolean;
  onClose: () => void;
  defaultDate?: {
    month: number;
    year: number;
  };
  getMonthYear?: (result: IMonthYearPickerType) => void;
}
const LINKING_ERROR =
  `The package 'react-native-month-year-date-picker' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ComponentName = 'MonthYearDatePickerView';
export const MonthYearDatePickerView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? MonthYearDatePicker
    : () => {
        throw new Error(LINKING_ERROR);
      };
