//
// Color.swift
// HTMLBridge
//

import SwiftUI

extension Color {
    func toHex() -> String {
        UIColor(self).toHex()
    }
}
