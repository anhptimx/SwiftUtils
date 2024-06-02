//
//  LoadingConfiguration.swift
//
//
//  Created by IMX on 3/6/24.
//

import Foundation
import UIKit

public struct LoadingConfiguration {
    public var padding: CGFloat
    public var minimumContainerWidth: CGFloat
    public var indicatorSize: CGFloat
    public var titleFontSize: UIFont
    public var subtitleFontSize: UIFont
    public var containerLayerCornerRadius: CGFloat

    public init(
        padding: CGFloat = 8.0,
        minimumContainerWidth: CGFloat = 150.0,
        indicatorSize: CGFloat = 40.0,
        titleFontSize: UIFont = .systemFont(ofSize: 20.0),
        subtitleFontSize: UIFont = .systemFont(ofSize: 16.0),
        containerLayerCornerRadius: CGFloat = 12.0
    ) {
        self.padding = padding
        self.minimumContainerWidth = minimumContainerWidth
        self.indicatorSize = indicatorSize
        self.titleFontSize = titleFontSize
        self.subtitleFontSize = subtitleFontSize
        self.containerLayerCornerRadius = containerLayerCornerRadius
    }
}
