//
// HTMLTextViewModel.swift
// HTMLBridge
//

import SwiftUI

final class HTMLTextViewModel: ObservableObject {
    // Content
    var content: String
    
    var fontName: String
    var fontSize: CGFloat
    var fontColor: UIColor
    
    // Additional Font Properties
    var characterSpacing: CGFloat
    var lineSpacing: CGFloat
    var alignment: NSTextAlignment
    
    // `UITextField` Properties
    var linkTextAttributes: [NSAttributedString.Key: Any]
    var isEditable: Bool
    var isScrollEnabled: Bool
    var isSelectable: Bool
    var dataDetectorTypes: UIDataDetectorTypes
    var backgroundColor: UIColor
    var textContainerInset: UIEdgeInsets
    var accessibilityIdentifier: String
    var lineFragmentPadding: CGFloat
    var maximumNumberOfLines: Int
    
    init() {
        content = ""
        
        fontName = ""
        fontSize = 12
        fontColor = .black
        
        characterSpacing = .zero
        lineSpacing = 1
        alignment = .left
        
        linkTextAttributes = [:]
        accessibilityIdentifier = ""
        
        isEditable = false
        isScrollEnabled = false
        isSelectable = true
        dataDetectorTypes = .link
        backgroundColor = .clear
        textContainerInset = .zero
        lineFragmentPadding = 0
        maximumNumberOfLines = 0
    }
}

extension HTMLTextViewModel {
    var htmlString: String {
        """
            <style>
               html * {
                   font-size: \(cssFontSize);
                   color: \(cssFontColor);
                   font-family: \(cssFontName) Helvetica;
               }
            </style>
            \(content)
        """
    }
    
    var cssFontName: String {
        fontName.isEmpty ? "" : "'\(fontName)',"
    }
    
    var cssFontSize: String {
        String(format: "%.2f", fontSize) + "px"
    }
    
    var cssFontColor: String {
        fontColor.toHex()
    }
    
    var nsAttributedString: NSAttributedString {
        let htmlText = htmlString.nsAttributedString
        let mutableText = NSMutableAttributedString(attributedString: htmlText)
        let range = NSRange(location: 0, length: mutableText.length)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        
        mutableText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return mutableText
    }
}
