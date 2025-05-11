//
// UIColor.swift
// HTMLBridge
//

import UIKit

extension UIColor {
    func toHex() -> String {
        let uiColor = self
        var hexColor = "#000"
        guard let components = uiColor.cgColor.components,
              components.count >= 3
        else { return hexColor }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        var alpha = Float(1.0)
        
        if components.count >= 4 {
            alpha = Float(components[3])
        }
        
        if alpha != Float(1.0) {
            hexColor = String(
                format: "%02lX%02lX%02lX%02lX",
                lroundf(red * 255),
                lroundf(green * 255),
                lroundf(blue * 255),
                lroundf(alpha * 255)
            )
        } else {
            hexColor = String(
                format: "%02lX%02lX%02lX",
                lroundf(red * 255),
                lroundf(green * 255),
                lroundf(blue * 255)
            )
        }
        
        return "#" + hexColor
    }
}
