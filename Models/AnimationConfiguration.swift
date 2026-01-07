//
//  AnimationConfiguration.swift
//  EditorialistIosUIAnimationAssignment
//
//  Created by Swapnil Dhiman on 07/01/26.
//
//  Centralized configuration for all animation timings, colors, and layout constants.
//  This makes it easy to adjust the animation feel without hunting through view code.
//

import UIKit

/// Central configuration for the "Place Order" animation sequence.
/// All magic numbers live here for easy tuning and maintenance.
enum AnimationConfig {
    
    // MARK: - Animation Durations
    
    enum Duration {
        /// Phase 1: Text swap animation (Place Order → Order placed)
        static let textSwap: TimeInterval = 0.35
        
        /// Phase 2: Button transitions from gray to white
        static let buttonToWhite: TimeInterval = 0.25
        
        /// Phase 2: Delay before white transition starts
        static let buttonToWhiteDelay: TimeInterval = 0.1
        
        /// Phase 3: Text mask disappearing animation
        static let textMaskDisappear: TimeInterval = 0.5
        
        /// Phase 4: Checkmark moves upward
        static let checkmarkMovesUp: TimeInterval = 0.4
        
        /// Phase 4: Small delay before checkmark starts moving
        static let checkmarkMovesUpDelay: TimeInterval = 0.05
        
        /// Phase 5: Labels fade out
        static let labelsFadeOut: TimeInterval = 0.2
        
        /// Phase 5: Success content slides up with spring
        static let successContentSlideUp: TimeInterval = 0.6
        
        /// Phase 5: Delay before content starts sliding
        static let successContentDelay: TimeInterval = 0.1
        
        /// Phase 6: Button returns to black
        static let buttonToBlack: TimeInterval = 0.3
        
        /// Phase 7: Text and chevron spread apart
        static let textChevronSpread: TimeInterval = 0.4
        
        /// Phase 7: Delay before spread animation
        static let textChevronSpreadDelay: TimeInterval = 0.1
    }
    
    // MARK: - Spring Animation Parameters
    
    enum Spring {
        /// Damping ratio for success content slide-up (0.0 = max bounce, 1.0 = no bounce)
        static let contentSlideDamping: CGFloat = 0.8
        
        /// Initial velocity for success content slide-up
        static let contentSlideVelocity: CGFloat = 0.5
    }
    
    // MARK: - Colors
    
    enum Colors {
        /// Button in its initial and final state
        static let buttonBlack = UIColor.black
        
        /// Button during the "Order placed" transition phase
        static let buttonGray = UIColor(white: 0.55, alpha: 1.0)
        
        /// Button when showing "Order placed" confirmation
        static let buttonWhite = UIColor.white
        
        /// Subtle border when button is white
        static let buttonBorder = UIColor(white: 0.85, alpha: 1.0)
        
        /// Separator line color
        static let separator = UIColor(white: 0.9, alpha: 1.0)
        
        /// Secondary text color (subtotal label)
        static let secondaryText = UIColor(white: 0.4, alpha: 1.0)
        
        /// Success checkmark circle background
        static let successCircleBackground = UIColor(white: 0.94, alpha: 1.0)
        
        /// Success checkmark icon color
        static let successCheckmarkTint = UIColor(white: 0.5, alpha: 1.0)
    }
    
    // MARK: - Layout Constants
    
    enum Layout {
        /// Height of the action button
        static let buttonHeight: CGFloat = 56
        
        /// Horizontal padding from screen edges
        static let horizontalPadding: CGFloat = 24
        
        /// Bottom padding below the button
        static let bottomPadding: CGFloat = 40
        
        /// Button corner radius
        static let buttonCornerRadius: CGFloat = 4
        
        /// Border width when button is white
        static let buttonBorderWidth: CGFloat = 1
        
        /// Spacing between subtotal section and button
        static let subtotalToButtonSpacing: CGFloat = 20
        
        /// Spacing below separator line
        static let separatorToSubtotalSpacing: CGFloat = 20
        
        /// Success checkmark circle diameter
        static let successCircleSize: CGFloat = 120
        
        /// Spacing below success circle to title
        static let successCircleToTitleSpacing: CGFloat = 24
        
        /// Spacing between title and subtitle
        static let titleToSubtitleSpacing: CGFloat = 12
        
        /// Gap between success content and footer
        static let successContentToFooterGap: CGFloat = 30
        
        /// How far the checkmark moves up in Phase 4
        static let checkmarkUpwardDistance: CGFloat = 60
        
        /// How far "Place Order" slides right when exiting
        static let placeOrderExitDistance: CGFloat = 150
        
        /// Starting position for "Order placed" (off-screen left)
        static let orderPlacedEntryOffset: CGFloat = -200
        
        /// Starting position for success content (below screen)
        static let successContentStartOffset: CGFloat = 300
    }
    
    // MARK: - Typography
    
    enum Typography {
        /// Button text font
        static let buttonText = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        /// Body text font (subtotal, price)
        static let bodyText = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        /// Price text font
        static let priceText = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        /// Success title font
        static let successTitle = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        /// Success subtitle font
        static let successSubtitle = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        /// Chevron font
        static let chevron = UIFont.systemFont(ofSize: 24, weight: .regular)
    }
    
    // MARK: - SF Symbols Configuration
    
    enum Symbols {
        /// Small checkmark next to "Order placed"
        static let buttonCheckmark = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        
        /// Floating checkmark that moves up
        static let floatingCheckmark = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        
        /// Large checkmark in success circle
        static let successCheckmark = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        
        /// Checkmark icon name
        static let checkmarkCircle = "checkmark.circle"
        
        /// Plain checkmark icon name
        static let checkmark = "checkmark"
    }
    
    // MARK: - Text Content
    
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

