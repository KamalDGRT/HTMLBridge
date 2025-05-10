//
// String.swift
// HTMLBridge
//

import Foundation

extension String {
    var nsAttributedString: NSAttributedString {
        var attributedString = NSAttributedString()
        guard let htmlData = self.data(using: .unicode)
        else { return attributedString }
        
        do {
            attributedString = try NSAttributedString(
                data: htmlData,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        } catch {
            return attributedString
        }
        
        return attributedString
    }
}
