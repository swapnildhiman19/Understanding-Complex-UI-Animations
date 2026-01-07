//
//  AnimationConfiguration.swift
//  EditorialistIosUIAnimationAssignment
//
//  Created by Swapnil Dhiman on 07/01/26.
//

import UIKit

// All the animation config lives here so it's easy to tweak
enum AnimationConfig {
    
    // MARK: - Timing
    
    enum Duration {
        static let textSwap: TimeInterval = 0.35
        static let buttonToWhite: TimeInterval = 0.25
        static let buttonToWhiteDelay: TimeInterval = 0.1
        static let textMaskDisappear: TimeInterval = 0.5
        static let checkmarkMovesUp: TimeInterval = 0.4
        static let checkmarkMovesUpDelay: TimeInterval = 0.05
        static let labelsFadeOut: TimeInterval = 0.2
        static let successContentSlideUp: TimeInterval = 0.6
        static let successContentDelay: TimeInterval = 0.1
        static let textChevronSpread: TimeInterval = 0.4
        static let textChevronSpreadDelay: TimeInterval = 0.1
        static let chevronRotation: TimeInterval = 0.3
    }
    
    enum Spring {
        static let contentSlideDamping: CGFloat = 0.8
        static let contentSlideVelocity: CGFloat = 0.5
    }
    
    // MARK: - Colors
    
    enum Colors {
        static let buttonBlack = UIColor.black
        static let buttonGray = UIColor(white: 0.55, alpha: 1.0)
        static let buttonWhite = UIColor.white
        static let buttonBorder = UIColor(white: 0.85, alpha: 1.0)
        static let separator = UIColor(white: 0.9, alpha: 1.0)
        static let secondaryText = UIColor(white: 0.4, alpha: 1.0)
        static let successCircleBackground = UIColor(white: 0.94, alpha: 1.0)
        static let successCheckmarkTint = UIColor(white: 0.5, alpha: 1.0)
    }
    
    // MARK: - Layout
    
    enum Layout {
        static let buttonHeight: CGFloat = 56
        static let horizontalPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 4
        static let buttonBorderWidth: CGFloat = 1
        static let subtotalToButtonSpacing: CGFloat = 20
        static let separatorToSubtotalSpacing: CGFloat = 20
        static let successCircleSize: CGFloat = 120
        static let successCircleToTitleSpacing: CGFloat = 24
        static let titleToSubtitleSpacing: CGFloat = 12
        static let successContentToFooterGap: CGFloat = 30
        static let checkmarkUpwardDistance: CGFloat = 60
        static let placeOrderExitDistance: CGFloat = 150
        static let orderPlacedEntryOffset: CGFloat = -200
        static let successContentStartOffset: CGFloat = 300
        static let continueLabelSlideOffset: CGFloat = 40
    }
    
    // MARK: - Typography
    
    enum Typography {
        static let buttonText = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let bodyText = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let priceText = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let successTitle = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let successSubtitle = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let chevron = UIFont.systemFont(ofSize: 24, weight: .regular)
    }
    
    // MARK: - SF Symbols
    
    enum Symbols {
        static let buttonCheckmark = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        static let floatingCheckmark = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        static let successCheckmark = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        static let checkmarkCircle = "checkmark.circle"
        static let checkmark = "checkmark"
    }
    
    // MARK: - Strings
    
    enum Text {
        static let placeOrder = "Place Order"
        static let orderPlaced = "Order placed"
        static let continueShopping = "Continue Shopping"
        static let chevron = "›"
        static let subtotal = "Subtotal"
        static let price = "$2,636"
        static let thankYouTitle = "Thank you, your order has\nbeen submitted"
        static let thankYouSubtitle = "We've received your order and our team is preparing\nyour pieces. You'll get an update soon."
    }
}
