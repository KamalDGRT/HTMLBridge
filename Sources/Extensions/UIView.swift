//
// UIView.swift
// HTMLBridge
//

import UIKit

extension UIView {
    func setAccessibilityIdentifier(_ identifier: String) {
        isAccessibilityElement = true
        accessibilityIdentifier = identifier
    }
}
