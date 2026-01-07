//
//  SuccessContentView.swift
//  EditorialistIosUIAnimationAssignment
//
//  Created by Swapnil Dhiman on 07/01/26.
//

import UIKit

final class SuccessContentView: UIView {
    
    // MARK: - UI
    
    private let checkmarkCircle: UIView = {
        let view = UIView()
        view.backgroundColor = AnimationConfig.Colors.successCircleBackground
        let size = AnimationConfig.Layout.successCircleSize
        view.layer.cornerRadius = size / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkmarkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: AnimationConfig.Symbols.checkmark,
            withConfiguration: AnimationConfig.Symbols.successCheckmark
        )
        imageView.tintColor = AnimationConfig.Colors.successCheckmarkTint
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.thankYouTitle
        label.font = AnimationConfig.Typography.successTitle
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = AnimationConfig.Text.thankYouSubtitle
        label.font = AnimationConfig.Typography.successSubtitle
        label.textColor = AnimationConfig.Colors.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        prepareForAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        prepareForAnimation()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(checkmarkCircle)
        checkmarkCircle.addSubview(checkmarkIcon)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        let size = AnimationConfig.Layout.successCircleSize
        
        NSLayoutConstraint.activate([
            checkmarkCircle.topAnchor.constraint(equalTo: topAnchor),
            checkmarkCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkmarkCircle.widthAnchor.constraint(equalToConstant: size),
            checkmarkCircle.heightAnchor.constraint(equalToConstant: size),
            
            checkmarkIcon.centerXAnchor.constraint(equalTo: checkmarkCircle.centerXAnchor),
            checkmarkIcon.centerYAnchor.constraint(equalTo: checkmarkCircle.centerYAnchor),
            
            titleLabel.topAnchor.constraint(
                equalTo: checkmarkCircle.bottomAnchor,
                constant: AnimationConfig.Layout.successCircleToTitleSpacing
            ),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: AnimationConfig.Layout.titleToSubtitleSpacing
            ),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Animation
    
    func prepareForAnimation() {
        transform = CGAffineTransform(
            translationX: 0,
            y: AnimationConfig.Layout.successContentStartOffset
        )
    }
    
    func animateIn(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: AnimationConfig.Duration.successContentSlideUp,
            delay: AnimationConfig.Duration.successContentDelay,
            usingSpringWithDamping: AnimationConfig.Spring.contentSlideDamping,
            initialSpringVelocity: AnimationConfig.Spring.contentSlideVelocity,
            options: [],
            animations: {
                self.transform = .identity
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    func resetToInitialState() {
        prepareForAnimation()
    }
}
