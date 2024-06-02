//
//  LoadingManager.swift
//
//
//  Created by IMX on 3/6/24.
//

import UIKit
import NVActivityIndicatorView

public enum UserInteractionEnabled {
    case enable, disable
}

public final class LoadingManager {
    private var containerView: UIView?
    private var overlayView: UIView?
    private var activityIndicatorView: NVActivityIndicatorView?

    private static let shared = LoadingManager()
    private lazy var defaultConfig: LoadingConfiguration = {
        return LoadingConfiguration()
    }()

    private init() {}

    public func configure(configuration: LoadingConfiguration) {
        self.defaultConfig = configuration
    }

    public static func show(userInteractionEnabled: UserInteractionEnabled = .disable, title: String? = nil, subtitle: String? = nil, titleColor: UIColor? = .lightGray, type: NVActivityIndicatorType = .lineSpinFadeLoader, activityIndicatorColor: UIColor? = .lightGray, backgroundColor: UIColor = .clear) {
        DispatchQueue.main.async {
            cleanup()

            guard let keyWindow = SwiftUtils.currentUIWindow() else { return }
            if userInteractionEnabled == .disable {
                shared.overlayView = UIView(frame: keyWindow.bounds)
                shared.overlayView?.backgroundColor = .clear
                shared.overlayView?.isUserInteractionEnabled = true
                keyWindow.addSubview(shared.overlayView!)
            }

            shared.containerView = UIView()
            shared.containerView?.backgroundColor = backgroundColor
            shared.containerView?.layer.cornerRadius = shared.defaultConfig.containerLayerCornerRadius
            shared.containerView?.clipsToBounds = true

            let titleLabel = UILabel()
            configure(label: titleLabel, withText: title, font: shared.defaultConfig.titleFontSize, color: titleColor, within: keyWindow)

            let subtitleLabel = UILabel()
            configure(label: subtitleLabel, withText: subtitle, font: shared.defaultConfig.subtitleFontSize, color: titleColor, within: keyWindow)

            let containerWidth = max(titleLabel.intrinsicContentSize.width, subtitleLabel.intrinsicContentSize.width) + shared.defaultConfig.padding * 2
            let effectiveContainerWidth = max(containerWidth, shared.defaultConfig.minimumContainerWidth)

            let totalHeight = titleLabel.frame.height + (subtitle != nil ? shared.defaultConfig.padding + subtitleLabel.frame.height : 0) + shared.defaultConfig.padding * 3 + shared.defaultConfig.indicatorSize

            shared.containerView?.frame = CGRect(x: 0, y: 0, width: effectiveContainerWidth, height: totalHeight)
            shared.containerView?.center = keyWindow.center

            // Add the activity indicator
            shared.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (effectiveContainerWidth - shared.defaultConfig.indicatorSize) / 2, y: shared.defaultConfig.padding, width: shared.defaultConfig.indicatorSize, height: shared.defaultConfig.indicatorSize), type: type, color: activityIndicatorColor)
            shared.containerView?.addSubview(shared.activityIndicatorView!)
            shared.activityIndicatorView?.startAnimating()

            // Add the title and subtitle labels
            titleLabel.center.x = effectiveContainerWidth / 2
            subtitleLabel.center.x = effectiveContainerWidth / 2

            titleLabel.frame.origin.y = shared.defaultConfig.padding * 2 + shared.defaultConfig.indicatorSize
            subtitleLabel.frame.origin.y = titleLabel.frame.maxY + shared.defaultConfig.padding

            shared.containerView?.addSubview(titleLabel)
            shared.containerView?.addSubview(subtitleLabel)

            if userInteractionEnabled == .disable {
                shared.overlayView?.addSubview(shared.containerView!)
            } else {
                keyWindow.addSubview(shared.containerView!)
            }
        }
    }

    private static func configure(label: UILabel, withText text: String?, font: UIFont, color: UIColor?, within window: UIWindow) {
        guard let text = text, !text.isEmpty else {
            label.frame = .zero
            return
        }

        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        label.textAlignment = .center

        let maxWidth = window.bounds.width - shared.defaultConfig.padding * 4 // Margins
        let size = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
    }

    public static func hide() {
        DispatchQueue.main.async {
            cleanup()
        }
    }

    private static func cleanup() {
        shared.activityIndicatorView?.stopAnimating()
        shared.activityIndicatorView?.removeFromSuperview()
        shared.containerView?.removeFromSuperview()
        shared.overlayView?.removeFromSuperview()

        shared.activityIndicatorView = nil
        shared.containerView = nil
        shared.overlayView = nil
    }
}
