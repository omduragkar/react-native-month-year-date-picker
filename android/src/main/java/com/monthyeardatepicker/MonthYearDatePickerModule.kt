package com.monthyeardatepicker

import android.app.AlertDialog
import android.content.Context
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.Paint
import android.os.Build
import android.view.Gravity
import android.view.ViewGroup
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.NumberPicker
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableMap
import java.util.Calendar

class MonthYearDatePickerModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private var selectedMonthName: String = ""
    private var selectedMonthNumber: Int = 0
    private var selectedYear: Int = 0

    override fun getName(): String {
        return "MonthYearDatePicker"
    }

    // Helper class to hold layout and NumberPickers
    class PickerLayout(val layout: FrameLayout, val monthPicker: NumberPicker, val yearPicker: NumberPicker)

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    @ReactMethod
    fun showPicker(callback: Callback) {
        val context = currentActivity ?: return

        val isDarkMode = context.resources.configuration.uiMode and
                Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES

        val dialogBuilder = if (isDarkMode) {
            AlertDialog.Builder(context, android.R.style.Theme_Material_Dialog)
        } else {
            AlertDialog.Builder(context)
        }

        val pickerLayout = createPickerLayout(context)

        dialogBuilder.setView(pickerLayout.layout)

        dialogBuilder.setPositiveButton("OK") { _, _ ->
            selectedMonthNumber = pickerLayout.monthPicker.value
            selectedMonthName = pickerLayout.monthPicker.displayedValues[selectedMonthNumber]
            selectedYear = pickerLayout.yearPicker.value

            val result: WritableMap = Arguments.createMap().apply {
                putString("monthName", selectedMonthName)
                putInt("monthNumber", selectedMonthNumber)
                putInt("year", selectedYear)
            }

            callback.invoke(result)
        }

        dialogBuilder.setNegativeButton("Cancel", null)
        val dialog = dialogBuilder.create()
        dialog.show()

        // Apply padding to the dialog view to ensure consistent spacing
        dialog.window?.decorView?.setPadding(32, 32, 32, 40)

        // Set the width of the dialog to match the parent width
        dialog.window?.setLayout(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
         // Set the button colors to match the month and year text color   
            val buttonColor = if (isDarkMode) Color.WHITE else Color.BLACK
            dialog.getButton(AlertDialog.BUTTON_POSITIVE)?.setTextColor(buttonColor)
            dialog.getButton(AlertDialog.BUTTON_NEGATIVE)?.setTextColor(buttonColor)
    }

    // Method to create the layout containing two NumberPickers and return a PickerLayout object
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun createPickerLayout(context: Context): PickerLayout {
        val frameLayout = FrameLayout(context)
        val layout = LinearLayout(context)
        layout.orientation = LinearLayout.HORIZONTAL
        layout.gravity = Gravity.CENTER_HORIZONTAL

        val padding = (16 * context.resources.displayMetrics.density).toInt()
        layout.setPadding(padding, padding, padding, padding)

        val currentYear = Calendar.getInstance().get(Calendar.YEAR)
        val currentMonth = Calendar.getInstance().get(Calendar.MONTH) + 1

        val monthPicker = NumberPicker(context).apply {
            minValue = 1
            maxValue = 12
            displayedValues = arrayOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
            value = currentMonth
            setTextColorBasedOnTheme(context)
        }

        val yearPicker = NumberPicker(context).apply {
            minValue = 1900
            maxValue = 2100
            value = currentYear
            setTextColorBasedOnTheme(context)
        }

        layout.addView(monthPicker)
        layout.addView(yearPicker)

        frameLayout.addView(layout)
        return PickerLayout(frameLayout, monthPicker, yearPicker)
    }

    private fun NumberPicker.setTextColorBasedOnTheme(context: Context) {
        val isDarkMode = context.resources.configuration.uiMode and
                Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES

        val color = if (isDarkMode) {
            Color.WHITE
        } else {
            Color.BLACK
        }

        try {
            val selectorWheelPaintField = NumberPicker::class.java.getDeclaredField("mSelectorWheelPaint")
            selectorWheelPaintField.isAccessible = true
            (selectorWheelPaintField.get(this) as Paint).color = color

            val count = this.childCount
            for (i in 0 until count) {
                val child = this.getChildAt(i)
                if (child is EditText) {
                    child.setTextColor(color)
                }
            }
            this.invalidate()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    // Getter and Setter functions
    @ReactMethod
    fun getSelectedMonthName(callback: Callback) {
        callback.invoke(selectedMonthName)
    }

    @ReactMethod
    fun getSelectedMonthNumber(callback: Callback) {
        callback.invoke(selectedMonthNumber)
    }

    @ReactMethod
    fun getSelectedYear(callback: Callback) {
        callback.invoke(selectedYear)
    }

    @ReactMethod
    fun setSelectedMonthName(monthName: String) {
        selectedMonthName = monthName
    }

    @ReactMethod
    fun setSelectedMonthNumber(monthNumber: Int) {
        selectedMonthNumber = monthNumber
    }

    @ReactMethod
    fun setSelectedYear(year: Int) {
        selectedYear = year
    }
}