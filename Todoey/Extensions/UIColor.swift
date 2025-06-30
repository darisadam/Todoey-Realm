//
//  UIColor.swift
//  Todoey
//
//  Created by Adam Daris Ryadhi on 30/06/25.
//

import UIKit

extension UIColor {
  // MARK: - Random Color
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
  
  // MARK: - Darken Color
  func darkened(by percentage: CGFloat) -> UIColor {
    // Clamp percentage between 0.0 and 1.0
    let clampedPercentage = max(0.0, min(1.0, percentage))
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // Get RGBA components
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Calculate darkening factor (0% = no change, 100% = black)
    let darkeningFactor = 1.0 - clampedPercentage
    
    return UIColor(
      red: red * darkeningFactor,
      green: green * darkeningFactor,
      blue: blue * darkeningFactor,
      alpha: alpha
    )
  }
  
  // MARK: - Lighten Color
  func lightened(by percentage: CGFloat) -> UIColor {
    // Clamp percentage between 0.0 and 1.0
    let clampedPercentage = max(0.0, min(1.0, percentage))
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // Get RGBA components
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Calculate lightening factor (0% = no change, 100% = white)
    let lighteningFactor = clampedPercentage
    
    return UIColor(
      red: red + (1.0 - red) * lighteningFactor,
      green: green + (1.0 - green) * lighteningFactor,
      blue: blue + (1.0 - blue) * lighteningFactor,
      alpha: alpha
    )
  }
  
  // MARK: - Contrast Color
  func contrastTo(_ color: UIColor, returnFlat: Bool = false) -> UIColor {
    var selfRed: CGFloat = 0, selfGreen: CGFloat = 0, selfBlue: CGFloat = 0, selfAlpha: CGFloat = 0
    var otherRed: CGFloat = 0, otherGreen: CGFloat = 0, otherBlue: CGFloat = 0, otherAlpha: CGFloat = 0
    
    // Get RGBA components for both colors
    self.getRed(&selfRed, green: &selfGreen, blue: &selfBlue, alpha: &selfAlpha)
    color.getRed(&otherRed, green: &otherGreen, blue: &otherBlue, alpha: &otherAlpha)
    
    if returnFlat {
      // Return either pure black or white based on luminance
      let selfLuminance = calculateLuminance(red: selfRed, green: selfGreen, blue: selfBlue)
      let otherLuminance = calculateLuminance(red: otherRed, green: otherGreen, blue: otherBlue)
      
      // Calculate contrast ratios with black and white
      let contrastWithBlack = (selfLuminance + 0.05) / (0.0 + 0.05)
      let contrastWithWhite = (1.0 + 0.05) / (selfLuminance + 0.05)
      
      // Return black or white based on which provides better contrast
      return contrastWithBlack > contrastWithWhite ? .black : .white
    } else {
      // Calculate inverted color for better visual contrast
      let contrastRed = 1.0 - otherRed
      let contrastGreen = 1.0 - otherGreen
      let contrastBlue = 1.0 - otherBlue
      
      // Adjust for better readability
      let adjustedRed = contrastRed < 0.5 ? contrastRed + 0.3 : contrastRed - 0.3
      let adjustedGreen = contrastGreen < 0.5 ? contrastGreen + 0.3 : contrastGreen - 0.3
      let adjustedBlue = contrastBlue < 0.5 ? contrastBlue + 0.3 : contrastBlue - 0.3
      
      return UIColor(
        red: max(0.0, min(1.0, adjustedRed)),
        green: max(0.0, min(1.0, adjustedGreen)),
        blue: max(0.0, min(1.0, adjustedBlue)),
        alpha: selfAlpha
      )
    }
  }
  
  private func calculateLuminance(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
    // Convert sRGB to linear RGB
    func srgbToLinear(_ component: CGFloat) -> CGFloat {
      if component <= 0.03928 {
        return component / 12.92
      } else {
        return pow((component + 0.055) / 1.055, 2.4)
      }
    }
    
    let linearRed = srgbToLinear(red)
    let linearGreen = srgbToLinear(green)
    let linearBlue = srgbToLinear(blue)
    
    // Calculate relative luminance using ITU-R BT.709 coefficients
    return 0.2126 * linearRed + 0.7152 * linearGreen + 0.0722 * linearBlue
  }
}
