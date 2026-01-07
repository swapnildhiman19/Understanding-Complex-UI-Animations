//
//  ActionButtonView.swift
//  EditorialistIosUIAnimationAssignment
//
//  Created by Swapnil Dhiman on 07/01/26.
//
//  A custom button view that handles the multi-phase "Place Order" animation.
//  Encapsulates all button-related UI elements and their animations.
//

import UIKit

// MARK: - Delegate Protocol

/// Delegate to notify the controller when animation phases complete or reset is requested.
protocol ActionButtonViewDelegate: AnyObject {
    func actionButtonDidTap(_ buttonView: ActionButtonView)
    func actionButtonDidCompletePhase(_ phase: ActionButtonView.AnimationPhase)
    func actionButtonDidRequestReset(_ buttonView: ActionButtonView)
}

// MARK: - ActionButtonView

/// A sophisticated animated button that transitions through multiple states:
/// "Place Order" → "Order placed ✓" → Checkmark only → "Continue Shopping"
final class ActionButtonView: UIView {
    
    // MARK: - Animation Phases
    
    enum AnimationPhase {
        case textSwap           // Phase 1: Place Order → Order placed
        case buttonToWhite      // Phase 2: Button becomes white
        case textMaskDisappear  // Phase 3: Text disappears, checkmark shifts left
        case checkmarkMovesUp   // Phase 4: Checkmark moves upward
        case buttonToBlack      // Phase 6: Button returns to black
        case textChevronSpread  // Phase 7: Text and chevron spread apart
    }
    
    // MARK: - Delegate
    
    weak var delegate: ActionButtonViewDelegate?
    
    // MARK: - UI Components
    
    /// The button background container
    private let buttonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AnimationConfig.Colors.buttonBlack
        view.layer.cornerRadius = AnimationConfig.Layout.buttonCornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// "Place Order" label - initial state
    private let placeOrderLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.placeOrder
        label.font = AnimationConfig.Typography.buttonText
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Container for "Order placed" text and checkmark
    private let orderPlacedContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    /// "Order placed" text label
    private let orderPlacedLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.orderPlaced
        label.font = AnimationConfig.Typography.buttonText
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Small checkmark next to "Order placed"
    private let buttonCheckmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: AnimationConfig.Symbols.checkmarkCircle,
            withConfiguration: AnimationConfig.Symbols.buttonCheckmark
        )
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Floating checkmark that moves up after text disappears
    private let floatingCheckmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: AnimationConfig.Symbols.checkmarkCircle,
            withConfiguration: AnimationConfig.Symbols.floatingCheckmark
        )
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    /// "Continue Shopping" label - final state
    private let continueLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.continueShopping
        label.font = AnimationConfig.Typography.buttonText
        label.textColor = .white
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Chevron ">" on the right side
    private let chevronLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.chevron
        label.font = AnimationConfig.Typography.chevron
        label.textColor = .white
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Button State
    
    /// Tracks the current state of the button for handling taps appropriately.
    enum ButtonState {
        case initial        // Ready to start animation
        case animating      // Animation in progress
        case completed      // Animation finished, ready to reset
    }
    
    // MARK: - Animation State
    
    private var textMaskLayer: CALayer?
    private var currentState: ButtonState = .initial
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupGesture()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(buttonContainer)
        
        NSLayoutConstraint.activate([
            buttonContainer.topAnchor.constraint(equalTo: topAnchor),
            buttonContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: AnimationConfig.Layout.buttonHeight)
        ])
        
        setupPlaceOrderLabel()
        setupOrderPlacedContainer()
        setupFloatingCheckmark()
        setupContinueShoppingLabels()
    }
    
    private func setupPlaceOrderLabel() {
        buttonContainer.addSubview(placeOrderLabel)
        
        NSLayoutConstraint.activate([
            placeOrderLabel.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            placeOrderLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor)
        ])
    }
    
    private func setupOrderPlacedContainer() {
        buttonContainer.addSubview(orderPlacedContainer)
        
        NSLayoutConstraint.activate([
            orderPlacedContainer.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            orderPlacedContainer.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            orderPlacedContainer.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Add label and checkmark to container
        orderPlacedContainer.addSubview(orderPlacedLabel)
        orderPlacedContainer.addSubview(buttonCheckmark)
        
        NSLayoutConstraint.activate([
            orderPlacedLabel.leadingAnchor.constraint(equalTo: orderPlacedContainer.leadingAnchor),
            orderPlacedLabel.centerYAnchor.constraint(equalTo: orderPlacedContainer.centerYAnchor),
            
            buttonCheckmark.leadingAnchor.constraint(equalTo: orderPlacedLabel.trailingAnchor, constant: 8),
            buttonCheckmark.centerYAnchor.constraint(equalTo: orderPlacedContainer.centerYAnchor),
            buttonCheckmark.widthAnchor.constraint(equalToConstant: 20),
            buttonCheckmark.heightAnchor.constraint(equalToConstant: 20),
            buttonCheckmark.trailingAnchor.constraint(equalTo: orderPlacedContainer.trailingAnchor)
        ])
        
        // Position off-screen to the left initially
        orderPlacedContainer.transform = CGAffineTransform(
            translationX: AnimationConfig.Layout.orderPlacedEntryOffset,
            y: 0
        )
    }
    
    private func setupFloatingCheckmark() {
        buttonContainer.addSubview(floatingCheckmark)
        
        NSLayoutConstraint.activate([
            floatingCheckmark.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            floatingCheckmark.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            floatingCheckmark.widthAnchor.constraint(equalToConstant: 24),
            floatingCheckmark.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupContinueShoppingLabels() {
        buttonContainer.addSubview(continueLabel)
        buttonContainer.addSubview(chevronLabel)
        
        NSLayoutConstraint.activate([
            continueLabel.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            continueLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),


            chevronLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            chevronLabel.leadingAnchor
                .constraint(equalTo: continueLabel.trailingAnchor)
        ])
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        buttonContainer.addGestureRecognizer(tap)
        buttonContainer.isUserInteractionEnabled = true
    }
    
    // MARK: - Gesture Handling
    
    @objc private func handleTap() {
        switch currentState {
        case .initial:
            // Start the animation sequence
            currentState = .animating
            delegate?.actionButtonDidTap(self)
            
        case .animating:
            // Animation in progress, ignore taps
            break
            
        case .completed:
            // Request reset to initial state
            delegate?.actionButtonDidRequestReset(self)
        }
    }
    
    // MARK: - Animation Methods
    
    /// Phase 1: "Place Order" exits right, "Order placed ✓" enters from left.
    /// Button background transitions from black to gray.
    func animatePhase1_TextSwap() {
        orderPlacedContainer.alpha = 1
        
        UIView.animate(
            withDuration: AnimationConfig.Duration.textSwap,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                // "Place Order" slides right and fades
                self.placeOrderLabel.transform = CGAffineTransform(
                    translationX: AnimationConfig.Layout.placeOrderExitDistance,
                    y: 0
                )
                self.placeOrderLabel.alpha = 0
                
                // "Order placed" slides in from left
                self.orderPlacedContainer.transform = .identity
                
                // Button transitions to gray
                self.buttonContainer.backgroundColor = AnimationConfig.Colors.buttonGray
            },
            completion: { _ in
                self.delegate?.actionButtonDidCompletePhase(.textSwap)
            }
        )
    }
    
    /// Phase 2: Button background fades from gray to white with a subtle border.
    func animatePhase2_ButtonToWhite() {
        UIView.animate(
            withDuration: AnimationConfig.Duration.buttonToWhite,
            delay: AnimationConfig.Duration.buttonToWhiteDelay,
            options: [.curveEaseInOut],
            animations: {
                self.buttonContainer.backgroundColor = AnimationConfig.Colors.buttonWhite
                self.buttonContainer.layer.borderWidth = AnimationConfig.Layout.buttonBorderWidth
                self.buttonContainer.layer.borderColor = AnimationConfig.Colors.buttonBorder.cgColor
            },
            completion: { _ in
                self.delegate?.actionButtonDidCompletePhase(.buttonToWhite)
            }
        )
    }
    
    /// Phase 3: "Order placed" text disappears via mask animation while container shifts left.
    /// The checkmark follows the disappearing text edge.
    func animatePhase3_TextMaskDisappear() {
        layoutIfNeeded()
        
        let textWidth = orderPlacedLabel.bounds.width
        let labelFrame = orderPlacedLabel.bounds
        
        // Create mask layer
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = labelFrame
        orderPlacedLabel.layer.mask = maskLayer
        self.textMaskLayer = maskLayer
        
        let duration = AnimationConfig.Duration.textMaskDisappear
        
        // Mask animation using Core Animation
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setCompletionBlock { [weak self] in
            self?.delegate?.actionButtonDidCompletePhase(.textMaskDisappear)
        }
        
        // Shrink mask width from left
        let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        widthAnimation.fromValue = labelFrame.width
        widthAnimation.toValue = 0
        widthAnimation.fillMode = .forwards
        widthAnimation.isRemovedOnCompletion = false
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = labelFrame.width / 2
        positionAnimation.toValue = 0
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        
        maskLayer.add(widthAnimation, forKey: "shrinkWidth")
        maskLayer.add(positionAnimation, forKey: "movePosition")
        
        maskLayer.bounds.size.width = 0
        maskLayer.position.x = 0
        
        CATransaction.commit()
        
        // Simultaneously shift the container left so checkmark follows
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.orderPlacedContainer.transform = CGAffineTransform(
                    translationX: -(textWidth / 2) - 4,
                    y: 0
                )
            },
            completion: nil
        )
    }
    
    /// Phase 4: Checkmark moves upward inside the button.
    func animatePhase4_CheckmarkMovesUp() {
        // Get current checkmark position after Phase 3 shift
        let checkmarkCenter = buttonCheckmark.superview?.convert(
            buttonCheckmark.center,
            to: buttonContainer
        ) ?? buttonContainer.center
        
        let buttonCenter = CGPoint(
            x: buttonContainer.bounds.width / 2,
            y: buttonContainer.bounds.height / 2
        )
        
        let offsetX = checkmarkCenter.x - buttonCenter.x
        
        // Hide text, show floating checkmark at current position
        orderPlacedLabel.alpha = 0
        buttonCheckmark.alpha = 0
        floatingCheckmark.alpha = 1
        floatingCheckmark.transform = CGAffineTransform(translationX: offsetX, y: 0)
        
        UIView.animate(
            withDuration: AnimationConfig.Duration.checkmarkMovesUp,
            delay: AnimationConfig.Duration.checkmarkMovesUpDelay,
            options: [.curveEaseInOut],
            animations: {
                self.floatingCheckmark.transform = CGAffineTransform(
                    translationX: offsetX,
                    y: -AnimationConfig.Layout.checkmarkUpwardDistance
                )
                self.floatingCheckmark.alpha = 0.6
            },
            completion: { _ in
                self.delegate?.actionButtonDidCompletePhase(.checkmarkMovesUp)
            }
        )
    }
    
    /// Fade out the floating checkmark (called during Phase 5).
    func fadeOutFloatingCheckmark() {
        UIView.animate(withDuration: AnimationConfig.Duration.labelsFadeOut) {
            self.floatingCheckmark.alpha = 0
        }
    }
    
    /// Phase 6: Button returns to black with "Continue Shopping" text appearing.
    func animatePhase6_ButtonToBlack() {
        orderPlacedContainer.alpha = 0
        
        UIView.animate(
            withDuration: AnimationConfig.Duration.buttonToBlack,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.buttonContainer.backgroundColor = AnimationConfig.Colors.buttonBlack
                self.buttonContainer.layer.borderWidth = 0
                self.continueLabel.alpha = 1
                self.chevronLabel.alpha = 1
            },
            completion: { _ in
                self.delegate?.actionButtonDidCompletePhase(.buttonToBlack)
            }
        )
    }
    
    /// Phase 7: "Continue Shopping" moves left, chevron moves right.
    func animatePhase7_TextChevronSpread() {
        let buttonWidth = buttonContainer.bounds.width
        let textWidth = continueLabel.intrinsicContentSize.width
        let chevronWidth = chevronLabel.intrinsicContentSize.width
        let padding = AnimationConfig.Layout.horizontalPadding
        
        // Text moves from center to left edge (with padding)
        let textTargetX = -(buttonWidth / 2) + padding + (textWidth / 2)
        
        // Chevron starts at continueLabel.trailing (not at center)
        // Its current center X = buttonWidth/2 + textWidth/2 + chevronWidth/2
        // Its target center X = buttonWidth - padding - chevronWidth/2
        // Transform = target - current
        let chevronTargetX = (buttonWidth / 2) - padding - textWidth / 2 - chevronWidth
        
        UIView.animate(
            withDuration: AnimationConfig.Duration.textChevronSpread,
            delay: AnimationConfig.Duration.textChevronSpreadDelay,
            options: [.curveEaseOut],
            animations: {
                self.continueLabel.transform = CGAffineTransform(translationX: textTargetX, y: 0)
                self.chevronLabel.transform = CGAffineTransform(translationX: chevronTargetX, y: 0)
            },
            completion: { _ in
                // Animation sequence complete - button is now tappable for reset
                self.currentState = .completed
                self.delegate?.actionButtonDidCompletePhase(.textChevronSpread)
            }
        )
    }
    
    // MARK: - Reset
    
    /// Resets the button to its initial "Place Order" state.
    /// Call this to allow the animation to be triggered again.
    func resetToInitialState() {
        // Reset state
        currentState = .initial
        
        // Remove any mask layer from previous animation
        orderPlacedLabel.layer.mask = nil
        textMaskLayer = nil
        
        // Reset button container appearance
        buttonContainer.backgroundColor = AnimationConfig.Colors.buttonBlack
        buttonContainer.layer.borderWidth = 0
        
        // Reset "Place Order" label
        placeOrderLabel.transform = .identity
        placeOrderLabel.alpha = 1
        
        // Reset "Order placed" container
        orderPlacedContainer.transform = CGAffineTransform(
            translationX: AnimationConfig.Layout.orderPlacedEntryOffset,
            y: 0
        )
        orderPlacedContainer.alpha = 0
        orderPlacedLabel.alpha = 1
        buttonCheckmark.alpha = 1
        
        // Reset floating checkmark
        floatingCheckmark.transform = .identity
        floatingCheckmark.alpha = 0
        
        // Reset "Continue Shopping" labels
        continueLabel.transform = .identity
        continueLabel.alpha = 0
        chevronLabel.transform = .identity
        chevronLabel.alpha = 0
    }
}

