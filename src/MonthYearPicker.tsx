// TODO: To work on this releasing Version 1.0.0 for Now

// import React, { useEffect } from 'react';
// import { NativeModules } from 'react-native';
// import type { IMonthYearPickerProps, IMonthYearPickerType } from './index';

// const { MonthYearDatePicker } = NativeModules;

// export const MonthYearPicker: React.FC<IMonthYearPickerProps> = ({
//   onDateChange,
//   isOpen,
//   onClose,
//   defaultDate,
//   getMonthYear,
// }) => {
//   const month = defaultDate?.month || new Date().getMonth() + 1;
//   const year = defaultDate?.year || new Date().getFullYear();

//   useEffect(() => {
//     if (isOpen) {
//       MonthYearDatePicker.showPicker((result: IMonthYearPickerType) => {
//         onDateChange(result);
//         onClose();
//       });
//     }
//     // eslint-disable-next-line react-hooks/exhaustive-deps
//   }, [isOpen]);

//   useEffect(() => {
//     if (isOpen && month && year) {
//       MonthYearDatePicker.setPicker(month, year);
//     }
//   }, [isOpen, month, year]);

//   useEffect(() => {
//     if (getMonthYear) {
//       MonthYearDatePicker.getPickerValue((result: IMonthYearPickerType) => {
//         getMonthYear(result);
//       });
//     }
//   }, [getMonthYear]);

//   return null;
// };
