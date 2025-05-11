# HTMLBridge

A `UIViewRepresentable` wrapper around `UITextView` for rendering HTML content.

## Features

- Render HTML content as plain or attributed text.
- Customize font, alignment, line spacing, and more.
- Detect and handle links with custom actions.

## Installation

Add this package to your Swift project using Swift Package Manager.

```
https://github.com/KamalDGRT/HTMLBridge
```

## Usage

### Basic Example

```swift
import SwiftUI
import HTMLBridge

struct ContentView: View {
    var body: some View {
        HtmlText(.string("<b>Hello, World!</b>"))
            .font(name: "Helvetica", size: 16, color: .black)
            .alignment(.center)
            .lineSpacing(1.5)
            .padding()
    }
}
```

[![image.png](https://i.postimg.cc/d0Sdbt5S/image.png)](https://postimg.cc/gw8nRdFv)

### Handling Link Taps

```swift
import SwiftUI
import HTMLBridge

struct ContentView: View {
    var body: some View {
        HtmlText(.string("Visit <a href='https://example.com'>Example</a>"))
            .linkTextAttributes([.foregroundColor: UIColor.blue])
            .onLinkTap { url in
                print("Tapped link: \(url)")
            }
            .padding()
    }
}
```

[![Screenshot-2025-05-11-at-8-51-35-AM.png](https://i.postimg.cc/brfGPGkL/Screenshot-2025-05-11-at-8-51-35-AM.png)](https://postimg.cc/2bTjFSHB)

### Using Attributed Strings

```swift
import SwiftUI
import HTMLBridge

struct ContentView: View {
    var body: some View {
        let attributedString = NSAttributedString(
            string: "This is an attributed string",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.red
            ]
        )
        return HtmlText(.attributedString(attributedString))
            .padding()
    }
}
```

[![Atributed-String.png](https://i.postimg.cc/k5VDtNyf/Atributed-String.png)](https://postimg.cc/VS8zxCpC)

### Customizing Appearance

```swift
import SwiftUI
import HTMLBridge

struct ContentView: View {
    var body: some View {
        HtmlText(.string("<p>Custom HTML content</p>"))
            .font(name: "Courier", size: 14, color: .darkGray)
            .lineSpacing(2.0)
            .characterSpacing(1.2)
            .backgroundColor(.lightGray)
            .isEditable(false)
            .isSelectable(true)
            .padding()
    }
}
```

[![Custom-Example.png](https://i.postimg.cc/c4XJ9k9F/Custom-Example.png)](https://postimg.cc/RNJ9qdzt)

---

### References & Credits

- [Color to Hex Conversion](https://blog.eidinger.info/from-hex-to-color-and-back-in-swiftui)
- [Size That Fits Implementation](https://github.com/thomsmed/ios-examples/blob/4c4c5b6bca18d970041a8d32f2239c298317a2ad/SwiftUIHTML/SwiftUIHTML/AttributedText.swift#L67)
- GitHub Co-pilot & ChatGPT for the Documentation :)
