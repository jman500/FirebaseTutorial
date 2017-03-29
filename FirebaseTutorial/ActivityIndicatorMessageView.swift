//
//  ActivityIndicatorMessageView.swift
//  FirebaseTutorial
//
//  Created by Jim Graham on 3/23/17.
//  Copyright © 2017 JMan500. All rights reserved.
//

import UIKit

fileprivate extension String {
    func minRequiredSize(withConstrainedWidth width: CGFloat, font: UIFont) -> CGSize {
        let constrainRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        return self.boundingRect(with: constrainRect,
                                 options: .truncatesLastVisibleLine,
                                 attributes: [NSFontAttributeName: font],
                                 context: nil).size
    }
}

class ActivityIndicatorMessageView: UIVisualEffectView {
    
    // Variables
    private var blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    private let roundedCornerRadius: CGFloat = 10.0
    private let minHorizontalSpaceOutsideView: CGFloat = 20.0
    private let horizontalSpaceBuffer: CGFloat = 18.0
    private let verticalSpaceBuffer: CGFloat = 15.0
    private var viewSize: CGSize = CGSize(width: 0.0, height: 0.0)
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    private let messageLabel = UILabel()
    private var messageLabelViewSize: CGSize = CGSize(width: 0.0, height: 0.0)
    private let messageLabelFont = UIFont.boldSystemFont(ofSize: 16.0)
    private let messageLabelLineBreakMode = NSLineBreakMode.byTruncatingTail

    
    // Properties
    var message: String = "" {
        didSet {
            messageLabel.text = message
            resizeViewAndSubviews()
        }
    }
    
    // Initializers
    init(message: String) {
        self.message = message
        messageLabel.text = message  // must set here because 'didSet' doesn't get called during initialization
        super.init(effect: blurEffect)
        self.setup()
    }
    
    // Overrides and Required Implementations
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            resizeViewAndSubviews()
        }
    }
    
    // Functions
    private func setup() {
        layer.cornerRadius = roundedCornerRadius
        layer.masksToBounds = true

        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.font = messageLabelFont
        messageLabel.textColor = UIColor.gray
        
        contentView.addSubview(activityIndicator)
        contentView.addSubview(messageLabel)
        hide()
    }
    
    private func setLabelViewSize() {
        if let superview = self.superview {
            let constrainedWidth: CGFloat = superview.frame.width - minHorizontalSpaceOutsideView - activityIndicator.frame.width - (3 * horizontalSpaceBuffer)
            messageLabelViewSize = message.minRequiredSize(withConstrainedWidth: constrainedWidth, font: messageLabelFont)
        }
    }
    
    private func setViewSize() {
        viewSize.width = activityIndicator.frame.width + messageLabelViewSize.width + 3 * horizontalSpaceBuffer
        viewSize.height = max(activityIndicator.frame.height, messageLabelViewSize.height) + 2 * verticalSpaceBuffer
    }
    
    private func setFrames() {
        if let superview = self.superview {
            self.frame = CGRect(origin: CGPoint(x: superview.center.x - viewSize.width / 2,
                                                y: superview.center.y - viewSize.height / 2),
                                size: viewSize)

            activityIndicator.frame.origin = CGPoint(x: horizontalSpaceBuffer,
                                                     y: (viewSize.height - activityIndicator.frame.height) / 2)

            messageLabel.frame = CGRect(origin: CGPoint(x: 2 * horizontalSpaceBuffer + activityIndicator.frame.width,
                                                        y: (viewSize.height - messageLabelViewSize.height) / 2),
                                        size: messageLabelViewSize)
        }
    }
    
    private func resizeViewAndSubviews() {
        if self.superview != nil {
            setLabelViewSize()
            setViewSize()
            setFrames()
        }
    }
    
    func show() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }
}
