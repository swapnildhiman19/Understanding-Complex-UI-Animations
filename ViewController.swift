//
//  ViewController.swift
//  EditorialistIosUIAnimationAssignment
//
//  Created by Swapnil Dhiman on 07/01/26.
//
//

import UIKit

// MARK: - ViewController

/// Orchestrates the multi-phase "Place Order" animation sequence.
/// Acts as the conductor, telling each view when to animate while
/// the views handle their own animation implementations.
final class ViewController: UIViewController {
    
    // MARK: - Views
    
    /// Footer container with white background (acts as mask for success content)
    private let footerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Horizontal separator line at the top of the footer
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = AnimationConfig.Colors.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// "Subtotal" label on the left
    private let subtotalLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.subtotal
        label.font = AnimationConfig.Typography.bodyText
        label.textColor = AnimationConfig.Colors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Price label on the right
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.price
        label.font = AnimationConfig.Typography.priceText
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The animated action button (handles phases 1-4, 6-7)
    private let actionButton = ActionButtonView()
    
    /// Success message content (handles phase 5)
    private let successContent = SuccessContentView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
        configureDelegate()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    /// Sets up the view hierarchy with proper z-ordering.
    /// Success content is placed BEHIND the footer so it slides up from underneath.
    private func configureHierarchy() {
        // Add footer first (will be on top)
        view.addSubview(footerContainer)
        
        // Insert success content BEHIND footer
        view.insertSubview(successContent, belowSubview: footerContainer)
        
        // Add footer subviews
        footerContainer.addSubview(separatorLine)
        footerContainer.addSubview(subtotalLabel)
        footerContainer.addSubview(priceLabel)
        footerContainer.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        successContent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        let padding = AnimationConfig.Layout.horizontalPadding
        
        NSLayoutConstraint.activate([
            // Footer container - pinned to bottom
            footerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Separator line
            separatorLine.topAnchor.constraint(equalTo: footerContainer.topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Subtotal label
            subtotalLabel.topAnchor.constraint(
                equalTo: separatorLine.bottomAnchor,
                constant: AnimationConfig.Layout.separatorToSubtotalSpacing
            ),
            subtotalLabel.leadingAnchor.constraint(
                equalTo: footerContainer.leadingAnchor,
                constant: padding
            ),
            
            // Price label
            priceLabel.centerYAnchor.constraint(equalTo: subtotalLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(
                equalTo: footerContainer.trailingAnchor,
                constant: -padding
            ),
            
            // Action button
            actionButton.topAnchor.constraint(
                equalTo: subtotalLabel.bottomAnchor,
                constant: AnimationConfig.Layout.subtotalToButtonSpacing
            ),
            actionButton.leadingAnchor.constraint(
                equalTo: footerContainer.leadingAnchor,
                constant: padding
            ),
            actionButton.trailingAnchor.constraint(
                equalTo: footerContainer.trailingAnchor,
                constant: -padding
            ),
            actionButton.bottomAnchor.constraint(
                equalTo: footerContainer.bottomAnchor,
                constant: -AnimationConfig.Layout.bottomPadding
            ),
            
            // Success content - positioned above footer
            successContent.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: padding
            ),
            successContent.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -padding
            ),
            successContent.bottomAnchor.constraint(
                equalTo: footerContainer.topAnchor,
                constant: -AnimationConfig.Layout.successContentToFooterGap
            )
        ])
    }
    
    private func configureDelegate() {
        actionButton.delegate = self
    }
}

// MARK: - ActionButtonViewDelegate

extension ViewController: ActionButtonViewDelegate {
    
    /// Called when the user taps the action button.
    /// Starts the animation sequence.
    func actionButtonDidTap(_ buttonView: ActionButtonView) {
        startAnimationSequence()
    }
    
    /// Called when the button completes an animation phase.
    /// Triggers the next phase in the sequence.
    func actionButtonDidCompletePhase(_ phase: ActionButtonView.AnimationPhase) {
        switch phase {
        case .textSwap:
            actionButton.animatePhase2_ButtonToWhite()
            
        case .buttonToWhite:
            actionButton.animatePhase3_TextMaskDisappear()
            
        case .textMaskDisappear:
            actionButton.animatePhase4_CheckmarkMovesUp()
            
        case .checkmarkMovesUp:
            animatePhase5_SuccessContentSlidesUp()
            
        case .buttonToBlack:
            actionButton.animatePhase7_TextChevronSpread()
            
        case .textChevronSpread:
            animationSequenceCompleted()
        }
    }
    
    /// Called when user taps the button after animation is complete.
    /// Resets everything to initial state.
    func actionButtonDidRequestReset(_ buttonView: ActionButtonView) {
        resetToInitialState()
    }
}

// MARK: - Animation Orchestration

private extension ViewController {
    
    /// Kicks off the animation sequence starting with Phase 1.
    func startAnimationSequence() {
        actionButton.animatePhase1_TextSwap()
    }
    
    /// Phase 5: Fades out footer labels and slides up success content.
    /// This is handled in the controller because it coordinates multiple views.
    func animatePhase5_SuccessContentSlidesUp() {
        // Fade out subtotal and price labels
        UIView.animate(withDuration: AnimationConfig.Duration.labelsFadeOut) {
            self.subtotalLabel.alpha = 0
            self.priceLabel.alpha = 0
        }
        
        // Tell button to fade its floating checkmark
        actionButton.fadeOutFloatingCheckmark()
        
        // Animate success content sliding up
        successContent.animateIn { [weak self] in
            self?.actionButton.animatePhase6_ButtonToBlack()
        }
    }
    
    /// Called when the entire animation sequence is complete.
    func animationSequenceCompleted() {
        // Animation complete - button is now ready for reset on next tap
    }
    
    /// Resets all views to their initial state, allowing the animation to be triggered again.
    func resetToInitialState() {
        // Reset the action button
        actionButton.resetToInitialState()
        
        // Reset the success content (move it back off-screen)
        successContent.resetToInitialState()
        
        // Restore footer labels
        subtotalLabel.alpha = 1
        priceLabel.alpha = 1
    }
}
