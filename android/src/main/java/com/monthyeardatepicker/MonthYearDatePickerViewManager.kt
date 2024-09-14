package com.monthyeardatepicker

import android.graphics.Color
import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import android.widget.LinearLayout

class MonthYearDatePickerViewManager : SimpleViewManager<LinearLayout>() {
    override fun getName(): String {
        return "MonthYearDatePickerView" // This should match ComponentName in JS
    }

    override fun createViewInstance(reactContext: ThemedReactContext): LinearLayout {
        return LinearLayout(reactContext)
    }

    @ReactProp(name = "color")
    fun setColor(view: View, color: String) {
        view.setBackgroundColor(Color.parseColor(color))
    }
}