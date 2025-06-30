//
//  UIColor.swift
//  Todoey
//
//  Created by Adam Daris Ryadhi on 30/06/25.
//

import UIKit

extension UIColor {
  static func randomColor() -> UIColor {
    return UIColor(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      alpha: 1.0
    )
  }
  
  // MARK: - Convert UIColor to Hex String
  func toHex(includeAlpha: Bool = false) -> String {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // Get RGBA components
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Convert to 0-255 range and create hex string
    let r = Int(red * 255)
    let g = Int(green * 255)
    let b = Int(blue * 255)
    
    if includeAlpha {
      let a = Int(alpha * 255)
      return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    } else {
      return String(format: "#%02X%02X%02X", r, g, b)
    }
  }
  
  // MARK: - Convert Hex String to UIColor
  convenience init?(hex: String) {
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // Remove # if present
    if hexString.hasPrefix("#") {
      hexString.removeFirst()
    }
    
    // Validate hex string length
    guard hexString.count == 6 || hexString.count == 8 else {
      return nil
    }
    
    // Convert hex string to integer
    var hexValue: UInt64 = 0
    guard Scanner(string: hexString).scanHexInt64(&hexValue) else {
      return nil
    }
    
    let red, green, blue, alpha: CGFloat
    
    if hexString.count == 8 {
      // RRGGBBAA format
      red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
      green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
      blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
      alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
    } else {
      // RRGGBB format (assume alpha = 1.0)
      red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
      green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
      blue  = CGFloat(hexValue & 0x0000FF)         / 255.0
      alpha = 1.0
    }
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  // MARK: - Create random color with hex persistence
  static func randomColorWithHex() -> (color: UIColor, hex: String) {
    let color = randomColor()
    let hex = color.toHex()
    return (color: color, hex: hex)
  }
}
