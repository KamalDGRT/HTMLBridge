//
// HTMLTextViewModel.swift
// HTMLBridge
//
// ViewModel for managing HTML text rendering and styling.

import SwiftUI

/// A ViewModel for managing and rendering HTML content with customizable styles.
final class HTMLTextViewModel: ObservableObject {
    // MARK: - Content Properties
    
    /// The HTML content to be rendered.
    var content: String
    
    /// The name of the font to be used in the HTML content.
    var fontName: String
    
    /// The size of the font in points.
    var fontSize: CGFloat
    
    /// The color of the font.
    var fontColor: UIColor
    
    // MARK: - Additional Font Properties
    
    /// The spacing between characters in the text.
    var characterSpacing: CGFloat
    
    /// The spacing between lines in the text.
    var lineSpacing: CGFloat
    
    /// The alignment of the text.
    var alignment: NSTextAlignment
    
    // MARK: - UITextField Properties
    
    /// Attributes for styling links in the text.
    var linkTextAttributes: [NSAttributedString.Key: Any]
    
    /// A Boolean value indicating whether the text is editable.
    var isEditable: Bool
    
    /// A Boolean value indicating whether scrolling is enabled.
    var isScrollEnabled: Bool
    
    /// A Boolean value indicating whether the text is selectable.
    var isSelectable: Bool
    
    /// The types of data (e.g., links, phone numbers) to detect in the text.
    var dataDetectorTypes: UIDataDetectorTypes
    
    /// The background color of the text container.
    var backgroundColor: UIColor
    
    /// The inset of the text container.
    var textContainerInset: UIEdgeInsets
    
    /// An identifier for accessibility purposes.
    var accessibilityIdentifier: String
    
    /// The padding inside the text container.
    var lineFragmentPadding: CGFloat
    
    /// The maximum number of lines to display.
    var maximumNumberOfLines: Int
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `HTMLTextViewModel` with default values.
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
    // MARK: - Computed Properties
    
    /// The HTML string representation of the content with applied styles.
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
    
    /// The CSS-compatible font name.
    var cssFontName: String {
        fontName.isEmpty ? "" : "'\(fontName)',"
    }
    
    /// The CSS-compatible font size in pixels.
    var cssFontSize: String {
        String(format: "%.2f", fontSize) + "px"
    }
    
    /// The CSS-compatible font color in hexadecimal format.
    var cssFontColor: String {
        fontColor.toHex()
    }
    
    /// The attributed string representation of the HTML content.
    var nsAttributedString: NSAttributedString {
        let htmlText = htmlString.nsAttributedString
        let mutableText = NSMutableAttributedString(attributedString: htmlText)
        let range = NSRange(location: 0, length: mutableText.length)
        
        // Configure paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        
        // Apply paragraph style to the entire text
        mutableText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return mutableText
    }
}
