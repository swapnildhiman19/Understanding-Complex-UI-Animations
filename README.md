# Editorialist iOS Animation Assignment

A UIKit implementation of the "Place Order" animation flow from the provided Figma design.

## Quick Start

1. Open `EditorialistIosUIAnimationAssignment.xcodeproj` in Xcode 15+
2. Run on iOS 16+ simulator
3. Tap "Place Order" to see the animation
4. Tap again after completion to reset and replay

---

## What I Built

The animation has 7 phases that chain together:

1. **Text Swap** : "Place Order" exits right while "Order placed ✓" slides in from left
2. **Button turns white** : with a subtle border
3. **Text disappears** : masked from left to right, checkmark follows along
4. **Checkmark moves up** : floats upward inside the button
5. **Success content appears** : slides up from behind the footer
6. **Button turns black** : "Continue Shopping ›" fades in
7. **Text spreads apart** : label goes left, chevron goes right

## Why UIKit?

I went with UIKit instead of SwiftUI because:

- The mask animation in Phase 3 needs `CALayer` manipulation
- Chaining animations with completion handlers is more predictable
- Easier to match exact Figma timing with imperative code

## Project Structure

```
├── Models/
│   └── AnimationConfiguration.swift   : All the timing/color/layout constants
├── Views/
│   ├── ActionButtonView.swift         : The button and its animations
│   └── SuccessContentView.swift       : Success message UI
└── ViewController.swift               : Coordinates everything
```

I pulled all the magic numbers into `AnimationConfiguration.swift` so timing tweaks are easy to make without digging through animation code.

## How the Animation Works

### The Tricky Parts

**Phase 3 (text disappearing):**
The text doesn't just fade — it gets clipped from left to right using a `CALayer` mask. At the same time, the whole container shifts left so the checkmark appears to follow the disappearing text edge.

```swift
// Mask shrinks while container translates
CATransaction.begin()
// ... mask animation
CATransaction.commit()

UIView.animate(withDuration: duration) {
    self.orderPlacedContainer.transform = CGAffineTransform(translationX: -(textWidth / 2) - 4, y: 0)
}
```

**Phase 5 (content slides up from behind):**
The success content is placed *behind* the footer in the view hierarchy, so it appears to emerge from underneath:

```swift
view.addSubview(footerContainer)
view.insertSubview(successContent, belowSubview: footerContainer)
```

### Timing
These are approximations based on watching the Figma prototype 

## Architecture

Followed MVC to keep things organized:

- **ActionButtonView** handles all button related animations and notifies the controller via delegate when each phase completes
- **SuccessContentView** just knows how to animate itself in/out
- **ViewController** chains the phases together and coordinates between views

This makes it easy to see the animation flow in one place (the switch statement in `actionButtonDidCompletePhase`).

## Reset Feature

After the animation completes, tapping the button again resets everything to the initial state. This makes it easy to demo the animation multiple times without restarting the app.

---

**Requirements:** Swift 5.7+, iOS 16+, Xcode 15+, no third-party libraries
