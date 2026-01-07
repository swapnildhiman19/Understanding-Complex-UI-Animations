# Editorialist iOS Animation Assignment

A UIKit implementation of the "Place Order" animation from the Figma design.

## Quick Start

1. Open the `.xcodeproj` in Xcode 15+
2. Run on iOS 16+ simulator
3. Tap "Place Order" to see the animation
4. Tap again to reset and replay

---

## The Animation

8 phases that chain together:

1. **Text swap** - "Place Order" slides out right, "Order placed ✓" slides in from left
2. **Button turns white** - subtle border appears
3. **Text disappears** - masked left-to-right, checkmark follows along
4. **Checkmark floats up** - moves upward inside the button
5. **Success content slides up** - emerges from behind the footer
6. **Button turns black** - "Continue Shopping" slides up (synced with step 5)
7. **Chevron sweeps in** - quarter-circle arc animation from top to right
8. **Text spreads apart** - label goes left, chevron goes right

## Why UIKit?

Went with UIKit over SwiftUI for a few reasons:

- Phase 3 needs direct `CALayer` mask manipulation
- Completion handler chaining is more predictable for sequencing
- Easier to match the Figma timing with imperative animation calls

## Project Structure

```
├── Models/
│   └── AnimationConfiguration.swift   - timing, colors, layout constants
├── Views/
│   ├── ActionButtonView.swift         - button + all its animations
│   └── SuccessContentView.swift       - success message view
└── ViewController.swift               - coordinates everything
```

All the magic numbers live in `AnimationConfiguration.swift` so tweaking timing or colors doesn't require digging through animation code.

## Interesting Bits

**Phase 3 - the text mask:**

The text doesn't just fade. It gets clipped from left to right using a `CALayer` mask while the container shifts left so the checkmark follows the disappearing edge.

```swift
// Mask shrinks while container translates
CATransaction.begin()
// ... mask animation
CATransaction.commit()

UIView.animate(withDuration: duration) {
    self.orderPlacedContainer.transform = CGAffineTransform(translationX: -(textWidth / 2) - 4, y: 0)
}
```

**Phase 5 - sliding up from behind:**

The success content is inserted *below* the footer in the view hierarchy, so it appears to emerge from underneath:

```swift
view.addSubview(footerContainer)
view.insertSubview(successContent, belowSubview: footerContainer)
```

**Phase 7 - chevron arc:**

The chevron sweeps in along a quarter-circle path using keyframe animation:

```swift
UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [.calculationModeLinear]) {
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
        self.chevronLabel.transform = CGAffineTransform(translationX: 0, y: -20)
    }
    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
        self.chevronLabel.transform = .identity
    }
}
```

## Architecture

Simple MVC:

- **ActionButtonView** - owns all button animations, notifies controller when each phase completes
- **SuccessContentView** - knows how to slide itself in/out
- **ViewController** - chains phases together, handles reset

The animation flow is easy to follow in `actionButtonDidCompletePhase` - just a switch statement that triggers the next phase.

## Reset

Tapping the button after the animation completes resets everything to initial state. No need to restart the app to see it again.

---

**Requirements:** Swift 5.7+, iOS 16+, Xcode 15+, no third-party libraries
