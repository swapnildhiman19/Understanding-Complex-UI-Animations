//
//  ActionButtonView.swift
//  EditorialistIosUIAnimationAssignment
//
//  Created by Swapnil Dhiman on 07/01/26.
//

import UIKit

protocol ActionButtonViewDelegate: AnyObject {
    func actionButtonDidTap(_ buttonView: ActionButtonView)
    func actionButtonDidCompletePhase(_ phase: ActionButtonView.AnimationPhase)
    func actionButtonDidRequestReset(_ buttonView: ActionButtonView)
}

final class ActionButtonView: UIView {
    
    enum AnimationPhase {
        case textSwap
        case buttonToWhite
        case textMaskDisappear
        case checkmarkMovesUp
        case buttonToBlack
        case chevronRotation
        case textChevronSpread
    }
    
    enum ButtonState {
        case initial
        case animating
        case completed
    }
    
    weak var delegate: ActionButtonViewDelegate?
    
    // MARK: - UI
    
    private let buttonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AnimationConfig.Colors.buttonBlack
        view.layer.cornerRadius = AnimationConfig.Layout.buttonCornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let placeOrderLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.placeOrder
        label.font = AnimationConfig.Typography.buttonText
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orderPlacedContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private let orderPlacedLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.orderPlaced
        label.font = AnimationConfig.Typography.buttonText
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private let continueLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.continueShopping
        label.font = AnimationConfig.Typography.buttonText
        label.textColor = .white
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.chevron
        label.font = AnimationConfig.Typography.chevron
        label.textColor = .white
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textMaskLayer: CALayer?
    private var currentState: ButtonState = .initial
    
    // MARK: - Init
    
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
        
        // Start off-screen to the left
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
            chevronLabel.leadingAnchor.constraint(equalTo: continueLabel.trailingAnchor)
        ])
        
        // Start below button, will slide up
        let slideOffset = AnimationConfig.Layout.continueLabelSlideOffset
        continueLabel.transform = CGAffineTransform(translationX: 0, y: slideOffset)
        
        // Chevron starts above and to the left (12 o'clock position for arc animation)
        chevronLabel.transform = CGAffineTransform(translationX: -20, y: -40)
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        buttonContainer.addGestureRecognizer(tap)
        buttonContainer.isUserInteractionEnabled = true
    }
    
    // MARK: - Tap Handling
    
    @objc private func handleTap() {
        switch currentState {
        case .initial:
            currentState = .animating
            delegate?.actionButtonDidTap(self)
        case .animating:
            break // ignore taps while animating
        case .completed:
            delegate?.actionButtonDidRequestReset(self)
        }
    }
    
    // MARK: - Animations
    
    // Phase 1: swap "Place Order" with "Order placed ✓"
    func animatePhase1TextSwap() {
        orderPlacedContainer.alpha = 1
        
        UIView.animate(
            withDuration: AnimationConfig.Duration.textSwap,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.placeOrderLabel.transform = CGAffineTransform(
                    translationX: AnimationConfig.Layout.placeOrderExitDistance,
                    y: 0
                )
                self.placeOrderLabel.alpha = 0
                self.orderPlacedContainer.transform = .identity
                self.buttonContainer.backgroundColor = AnimationConfig.Colors.buttonGray
            },
            completion: { _ in
                self.delegate?.actionButtonDidCompletePhase(.textSwap)
            }
        )
    }
    
    // Phase 2: button goes white
    func animatePhase2ButtonToWhite() {
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
    
    // Phase 3: text disappears with mask, checkmark follows
    func animatePhase3TextMaskDisappear() {
        layoutIfNeeded()
        
        let textWidth = orderPlacedLabel.bounds.width
        let labelFrame = orderPlacedLabel.bounds
        
        // Create mask that we'll shrink to hide the text
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = labelFrame
        orderPlacedLabel.layer.mask = maskLayer
        self.textMaskLayer = maskLayer
        
        let duration = AnimationConfig.Duration.textMaskDisappear
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setCompletionBlock { [weak self] in
            self?.delegate?.actionButtonDidCompletePhase(.textMaskDisappear)
        }
        
        // Shrink mask from left
        let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        widthAnimation.fromValue = labelFrame.width
        widthAnimation.toValue = 0
        widthAnimation.fillMode = .forwards
        widthAnimation.isRemovedOnCompletion = false
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = labelFrame.width / 2
        positionAnimation.toValue = labelFrame.width
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        
        maskLayer.add(widthAnimation, forKey: "shrinkWidth")
        maskLayer.add(positionAnimation, forKey: "movePosition")
        maskLayer.bounds.size.width = 0
        maskLayer.position.x = labelFrame.width
        
        CATransaction.commit()
        
        // Shift container left so checkmark follows the disappearing text
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
    
    // Phase 4: checkmark floats up
    func animatePhase4CheckmarkMovesUp() {
        // Figure out where the checkmark ended up after phase 3
        let checkmarkCenter = buttonCheckmark.superview?.convert(
            buttonCheckmark.center,
            to: buttonContainer
        ) ?? buttonContainer.center
        
        let buttonCenter = CGPoint(
            x: buttonContainer.bounds.width / 2,
            y: buttonContainer.bounds.height / 2
        )
        let offsetX = checkmarkCenter.x - buttonCenter.x
        
        // Hide the original, show floating one at same spot
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
    
    func fadeOutFloatingCheckmark() {
        UIView.animate(withDuration: AnimationConfig.Duration.labelsFadeOut) {
            self.floatingCheckmark.alpha = 0
        }
    }
    
    // Phase 6: button goes black, "Continue Shopping" slides up (synced with success content)
    func animatePhase6ButtonToBlack() {
        orderPlacedContainer.alpha = 0
        continueLabel.alpha = 1
        
        // Use same timing as success content so they finish together
        UIView.animate(
            withDuration: AnimationConfig.Duration.successContentSlideUp,
            delay: AnimationConfig.Duration.successContentDelay,
            usingSpringWithDamping: AnimationConfig.Spring.contentSlideDamping,
            initialSpringVelocity: AnimationConfig.Spring.contentSlideVelocity,
            options: [],
            animations: {
                self.buttonContainer.backgroundColor = AnimationConfig.Colors.buttonBlack
                self.buttonContainer.layer.borderWidth = 0
                self.continueLabel.transform = .identity
            },
            completion: { _ in
                self.delegate?.actionButtonDidCompletePhase(.buttonToBlack)
            }
        )
    }
    
    // Phase 6b: chevron sweeps in a quarter-circle arc (12 o'clock → 3 o'clock)
    func animateChevronRotation() {
        chevronLabel.alpha = 1
        
        UIView.animateKeyframes(
            withDuration: AnimationConfig.Duration.chevronRotation,
            delay: 0,
            options: [.calculationModeLinear],
            animations: {
                // First half: move right and start coming down
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.chevronLabel.transform = CGAffineTransform(translationX: 0, y: -20)
                }
                // Second half: land with small gap from text
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.chevronLabel.transform = CGAffineTransform(translationX: 4, y: 0)
                }
            },
            completion: { _ in
                self.delegate?.actionButtonDidCompletePhase(.chevronRotation)
            }
        )
    }
    
    // Phase 7: spread text and chevron apart
    func animatePhase7TextChevronSpread() {
        let buttonWidth = buttonContainer.bounds.width
        let textWidth = continueLabel.intrinsicContentSize.width
        let chevronWidth = chevronLabel.intrinsicContentSize.width
        let padding = AnimationConfig.Layout.horizontalPadding
        
        // Text goes to left edge
        let textTargetX = -(buttonWidth / 2) + padding + (textWidth / 2)
        
        // Chevron goes to right edge (accounting for its starting position next to text)
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
                self.currentState = .completed
                self.delegate?.actionButtonDidCompletePhase(.textChevronSpread)
            }
        )
    }
    
    // MARK: - Reset
    
    func resetToInitialState() {
        currentState = .initial
        
        // Clear the mask from phase 3
        orderPlacedLabel.layer.mask = nil
        textMaskLayer = nil
        
        // Reset button appearance
        buttonContainer.backgroundColor = AnimationConfig.Colors.buttonBlack
        buttonContainer.layer.borderWidth = 0
        
        // Reset all the labels and transforms
        placeOrderLabel.transform = .identity
        placeOrderLabel.alpha = 1
        
        orderPlacedContainer.transform = CGAffineTransform(
            translationX: AnimationConfig.Layout.orderPlacedEntryOffset,
            y: 0
        )
        orderPlacedContainer.alpha = 0
        orderPlacedLabel.alpha = 1
        buttonCheckmark.alpha = 1
        
        floatingCheckmark.transform = .identity
        floatingCheckmark.alpha = 0
        
        // Reset to initial transforms
        let slideOffset = AnimationConfig.Layout.continueLabelSlideOffset
        continueLabel.transform = CGAffineTransform(translationX: 0, y: slideOffset)
        continueLabel.alpha = 0
        chevronLabel.transform = CGAffineTransform(translationX: -20, y: -40)
        chevronLabel.alpha = 0
    }
}
