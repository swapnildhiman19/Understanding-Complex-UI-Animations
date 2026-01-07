//
//  ViewController.swift
//  EditorialistIosUIAnimationAssignment
//
//  Created by Swapnil Dhiman on 07/01/26.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - UI
    
    // Footer has white bg so success content appears to slide from behind
    private let footerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = AnimationConfig.Colors.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subtotalLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.subtotal
        label.font = AnimationConfig.Typography.bodyText
        label.textColor = AnimationConfig.Colors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.price
        label.font = AnimationConfig.Typography.priceText
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton = ActionButtonView()
    private let successContent = SuccessContentView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        actionButton.delegate = self
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(footerContainer)
        // Put success content behind footer so it slides up from underneath
        view.insertSubview(successContent, belowSubview: footerContainer)
        
        footerContainer.addSubview(separatorLine)
        footerContainer.addSubview(subtotalLabel)
        footerContainer.addSubview(priceLabel)
        footerContainer.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        successContent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        let padding = AnimationConfig.Layout.horizontalPadding
        
        NSLayoutConstraint.activate([
            footerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            separatorLine.topAnchor.constraint(equalTo: footerContainer.topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            subtotalLabel.topAnchor.constraint(
                equalTo: separatorLine.bottomAnchor,
                constant: AnimationConfig.Layout.separatorToSubtotalSpacing
            ),
            subtotalLabel.leadingAnchor.constraint(
                equalTo: footerContainer.leadingAnchor,
                constant: padding
            ),
            
            priceLabel.centerYAnchor.constraint(equalTo: subtotalLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(
                equalTo: footerContainer.trailingAnchor,
                constant: -padding
            ),
            
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
            
            successContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            successContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            successContent.bottomAnchor.constraint(
                equalTo: footerContainer.topAnchor,
                constant: -AnimationConfig.Layout.successContentToFooterGap
            )
        ])
    }
}

// MARK: - ActionButtonViewDelegate

extension ViewController: ActionButtonViewDelegate {
    
    func actionButtonDidTap(_ buttonView: ActionButtonView) {
        actionButton.animatePhase1TextSwap()
    }
    
    func actionButtonDidCompletePhase(_ phase: ActionButtonView.AnimationPhase) {
        switch phase {
        case .textSwap:
            actionButton.animatePhase2ButtonToWhite()
        case .buttonToWhite:
            actionButton.animatePhase3TextMaskDisappear()
        case .textMaskDisappear:
            actionButton.animatePhase4CheckmarkMovesUp()
        case .checkmarkMovesUp:
            animatePhase5()
        case .buttonToBlack:
            actionButton.animatePhase7TextChevronSpread()
        case .textChevronSpread:
            break // done!
        }
    }
    
    func actionButtonDidRequestReset(_ buttonView: ActionButtonView) {
        actionButton.resetToInitialState()
        successContent.resetToInitialState()
        subtotalLabel.alpha = 1
        priceLabel.alpha = 1
    }
}

// MARK: - Phase 5

private extension ViewController {
    
    // Phase 5 lives here because it coordinates between button + success content
    func animatePhase5() {
        UIView.animate(withDuration: AnimationConfig.Duration.labelsFadeOut) {
            self.subtotalLabel.alpha = 0
            self.priceLabel.alpha = 0
        }
        
        actionButton.fadeOutFloatingCheckmark()
        
        successContent.animateIn { [weak self] in
            self?.actionButton.animatePhase6ButtonToBlack()
        }
    }
}
