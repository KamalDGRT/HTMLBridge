//
// HTMLText.swift
// HTMLBridge
//

import SwiftUI

/// Represents the type of HTML content to be rendered.
public enum HtmlContentType: Equatable {
    /// An attributed string representation of the content.
    case attributedString(NSAttributedString)
    /// A plain string representation of the content.
    case string(String)
}

/// A SwiftUI `UIViewRepresentable` for rendering HTML content in a `UITextView`.
public struct HtmlText: UIViewRepresentable {
    /// The type of HTML content to render.
    public let stringType: HtmlContentType
    
    /// An optional action to handle link taps.
    private var linkTapAction: ((URL) -> Void)?
    
    /// The ViewModel for managing the HTML text's appearance and behavior.
    @ObservedObject private var viewModel: HTMLTextViewModel
    
    /// Initializes a new `HtmlText` instance.
    /// - Parameters:
    ///   - stringType: The type of HTML content to render.
    ///   - customTapAction: An optional closure to handle link taps.
    public init(
        _ stringType: HtmlContentType,
        customTapAction: ((URL) -> Void)? = nil
    ) {
        self.stringType = stringType
        self.linkTapAction = customTapAction
        self.viewModel = HTMLTextViewModel()
    }
    
    /// Creates the `UITextView` instance.
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        let uiTextView = UITextView()
        uiTextView.delegate = context.coordinator
        uiTextView.textAlignment = viewModel.alignment
        uiTextView.isScrollEnabled = viewModel.isScrollEnabled
        uiTextView.isEditable = viewModel.isEditable
        uiTextView.isSelectable = viewModel.isSelectable
        uiTextView.dataDetectorTypes = viewModel.dataDetectorTypes
        
        uiTextView.linkTextAttributes = viewModel.linkTextAttributes
        uiTextView.backgroundColor = viewModel.backgroundColor
        uiTextView.textContainerInset = viewModel.textContainerInset
        uiTextView.textContainer.lineFragmentPadding = viewModel.lineFragmentPadding
        uiTextView.textContainer.maximumNumberOfLines = viewModel.maximumNumberOfLines
        
        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiTextView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        uiTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let accessibilityIdentifier = viewModel.accessibilityIdentifier
        if !accessibilityIdentifier.isEmpty {
            uiTextView.setAccessibilityIdentifier(accessibilityIdentifier)
        }
        
        return uiTextView
    }
    
    /// Updates the `UITextView` with new content or styles.
    public func updateUIView(
        _ uiTextView: UITextView,
        context: UIViewRepresentableContext<Self>
    ) {
        DispatchQueue.main.async {
            switch stringType {
            case .attributedString(let attributedString):
                uiTextView.attributedText = attributedString
            case .string(let string):
                viewModel.content = string
                uiTextView.attributedText = viewModel.nsAttributedString
            }
        }
    }
    
    /// Calculates the size that fits the proposed size.
    public func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView uiTextView: UITextView,
        context: Context
    ) -> CGSize? {
        if let width = proposal.width {
            let proposedSize = CGSize(width: width, height: .infinity)
            let fittingSize = uiTextView.systemLayoutSizeFitting(
                proposedSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            return CGSize(width: proposedSize.width, height: fittingSize.height)
        } else {
            return nil
        }
    }
    
    /// A coordinator to handle `UITextView` delegate methods.
    final public class Coordinator: NSObject, UITextViewDelegate {
        /// The parent `HtmlText` instance.
        var parent: HtmlText
        
        /// Initializes the coordinator with the parent `HtmlText`.
        init(parent: HtmlText) {
            self.parent = parent
        }
        
        /// Handles link tap actions.
        func handleLinkTapAction(_ URL: URL) {
            if let linkTapAction = parent.linkTapAction {
                linkTapAction(URL)
            } else {
                if UIApplication.shared.canOpenURL(URL) {
                    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
                }
            }
        }
        
        /// Handles primary actions for text items.
        public func textView(
            _ textView: UITextView,
            primaryActionFor textItem: UITextItem,
            defaultAction: UIAction
        ) -> UIAction? {
            if case .link(let url) = textItem.content {
                print(url)
                handleLinkTapAction(url)
            }
            return nil
        }
        
        /// Configures the menu for text items.
        public func textView(
            _ textView: UITextView,
            menuConfigurationFor textItem: UITextItem,
            defaultMenu: UIMenu
        ) -> UITextItem.MenuConfiguration? {
            if case .link(_) = textItem.content {
                return nil // Prevent menu for links
            }
            return .init(menu: defaultMenu) // Show default menu
        }
    }
    
    /// Creates the coordinator for the `HtmlText`.
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

public extension HtmlText {
    /// Sets the font properties for the HTML text.
    func font(
        name: String,
        size: CGFloat,
        color: UIColor = .black
    ) -> Self {
        viewModel.fontName = name
        viewModel.fontSize = size
        viewModel.fontColor = color
        return self
    }
    
    /// Sets the text alignment.
    func alignment(_ alignment: NSTextAlignment) -> Self {
        viewModel.alignment = alignment
        return self
    }
    
    /// Sets the foreground color of the text.
    func foregroundColor(_ color: UIColor) -> Self {
        viewModel.fontColor = color
        return self
    }
    
    /// Sets the attributes for styling links in the text.
    func linkTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        viewModel.linkTextAttributes = attributes
        return self
    }
    
    /// Sets the line spacing for the text.
    func lineSpacing(_ lineHeight: CGFloat) -> Self {
        viewModel.lineSpacing = lineHeight
        return self
    }
    
    /// Sets the character spacing for the text.
    func characterSpacing(_ spacing: CGFloat) -> Self {
        viewModel.characterSpacing = spacing
        return self
    }
    
    /// Sets whether the text is editable.
    func isEditable(_ isEditable: Bool) -> Self {
        viewModel.isEditable = isEditable
        return self
    }
    
    /// Sets whether scrolling is enabled.
    func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        viewModel.isScrollEnabled = isScrollEnabled
        return self
    }
    
    /// Sets whether the text is selectable.
    func isSelectable(_ isSelectable: Bool) -> Self {
        viewModel.isSelectable = isSelectable
        return self
    }
    
    /// Sets the types of data to detect in the text.
    func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        viewModel.dataDetectorTypes = types
        return self
    }
    
    /// Sets the background color of the text container.
    func backgroundColor(_ color: UIColor) -> Self {
        viewModel.backgroundColor = color
        return self
    }
    
    /// Sets the padding inside the text container.
    func lineFragmentPadding(_ padding: CGFloat) -> Self {
        viewModel.lineFragmentPadding = padding
        return self
    }
    
    /// Sets the maximum number of lines to display.
    func maximumNumberOfLines(_ lines: Int) -> Self {
        viewModel.maximumNumberOfLines = lines
        return self
    }
}
