import { useState } from 'react';
import { Button, StyleSheet, View } from 'react-native';
import { MonthYearDatePickerView } from 'react-native-month-year-date-picker';

export default function App() {
  const [value, setValue] = useState<string | null>(null);
  console.log({
    value,
  });
  return (
    <View style={styles.container}>
      <Button
        title="Show MonthYearDatePicker"
        onPress={() => {
          MonthYearDatePickerView?.showPicker(setValue);
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
