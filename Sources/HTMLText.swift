//
// HTMLText.swift
// HTMLBridge
//

import SwiftUI

public enum HtmlContentType: Equatable {
    case attributedString(NSAttributedString)
    case string(String)
}

public struct HtmlText: UIViewRepresentable {
    public let stringType: HtmlContentType
    private var linkTapAction: ((URL) -> Void)?
    @ObservedObject private var viewModel: HTMLTextViewModel
    
    public init(
        _ stringType: HtmlContentType,
        customTapAction: ((URL) -> Void)? = nil
    ) {
        self.stringType = stringType
        self.linkTapAction = customTapAction
        self.viewModel = HTMLTextViewModel()
    }
    
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
    
    final public class Coordinator: NSObject, UITextViewDelegate {
        var parent: HtmlText
        
        init(parent: HtmlText) {
            self.parent = parent
        }
        
        func handleLinkTapAction(_ URL: URL) {
            if let linkTapAction = parent.linkTapAction {
                linkTapAction(URL)
            } else {
                if UIApplication.shared.canOpenURL(URL) {
                    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
                }
            }
        }
        
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
        
        public func textView(
            _ textView: UITextView,
            menuConfigurationFor textItem: UITextItem,
            defaultMenu: UIMenu
        ) -> UITextItem.MenuConfiguration? {
            if case .link(_) = textItem.content {
                return nil // prevent menu
            }
            return .init(menu: defaultMenu) // show default menu
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

public extension HtmlText {
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
    
    func alignment(_ alignment: NSTextAlignment) -> Self {
        viewModel.alignment = alignment
        return self
    }
    
    func foregroundColor(_ color: UIColor) -> Self {
        viewModel.fontColor = color
        return self
    }
    
    func linkTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        viewModel.linkTextAttributes = attributes
        return self
    }
    
    func lineSpacing(_ lineHeight: CGFloat) -> Self {
        viewModel.lineSpacing = lineHeight
        return self
    }
    
    func characterSpacing(_ spacing: CGFloat) -> Self {
        viewModel.characterSpacing = spacing
        return self
    }
    
    func isEditable(_ isEditable: Bool) -> Self {
        viewModel.isEditable = isEditable
        return self
    }
    
    func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        viewModel.isScrollEnabled = isScrollEnabled
        return self
    }
    
    func isSelectable(_ isSelectable: Bool) -> Self {
        viewModel.isSelectable = isSelectable
        return self
    }
    
    func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        viewModel.dataDetectorTypes = types
        return self
    }
    
    func backgroundColor(_ color: UIColor) -> Self {
        viewModel.backgroundColor = color
        return self
    }
    
    func lineFragmentPadding(_ padding: CGFloat) -> Self {
        viewModel.lineFragmentPadding = padding
        return self
    }
    
    func maximumNumberOfLines(_ lines: Int) -> Self {
        viewModel.maximumNumberOfLines = lines
        return self
    }
}
