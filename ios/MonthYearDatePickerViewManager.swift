@objc(MonthYearDatePickerViewManager)
class MonthYearDatePickerViewManager: RCTViewManager {

  override func view() -> (UIView) {
    return MonthYearDatePickerView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
}

class MonthYearDatePickerView : UIView {

  @objc var color: String = "" {
    didSet {
      self.backgroundColor = hexStringToUIColor(hexColor: color)
    }
  }

  func hexStringToUIColor(hexColor: String) -> UIColor {
    var hexColor = hexColor
    if hexColor.hasPrefix("#") {
      hexColor.remove(at: hexColor.startIndex)
    }

    var color: UInt64 = 0
    Scanner(string: hexColor).scanHexInt64(&color)

    let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
    let b = CGFloat(color & 0x0000FF) / 255.0

    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
  }
}