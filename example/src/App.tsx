import { Button, StyleSheet, View } from 'react-native';
import { MonthYearDatePickerView } from 'react-native-month-year-date-picker';

export default function App() {
  const handleDateSelected = (result: {
    monthName: string;
    monthNumber: number;
    year: number;
  }) => {
    console.log({
      monthName: result.monthName,
      monthNumber: result.monthNumber,
      year: result.year,
    });
  };

  const setDefaultDate = () => {
    // Set default values to October (index 10) and 2024
    MonthYearDatePickerView.setPicker(10, 2029);
  };

  const getSelectedDate = () => {
    MonthYearDatePickerView.getPickerValue(
      (result: { monthName: string; monthNumber: number; year: number }) => {
        console.log('Selected', result);
      }
    );
  };

  return (
    <View style={styles.container}>
      <Button
        title="Show MonthYearDatePicker"
        onPress={() => {
          MonthYearDatePickerView.showPicker(
            (result: {
              monthName: string;
              monthNumber: number;
              year: number;
            }) => {
              handleDateSelected(result);
            }
          );
        }}
      />
      <Button title="Set Default Date" onPress={setDefaultDate} />
      <Button title="Get Selected Date" onPress={getSelectedDate} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
