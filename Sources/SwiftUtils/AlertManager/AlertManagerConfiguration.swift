//
//  AlertManagerConfiguration.swift
//
//
//  Created by IMX on 3/6/24.
//

import Foundation

public struct AlertManagerConfiguration {
    public var title: String
    public var message: String
    public var okActionTitle: String
    public var cancelActionTitle: String
    public var destructiveActionTitle: String

    public init(
        title: String = "Default Title",
        message: String = "Default Message",
        okActionTitle: String = "OK",
        cancelActionTitle: String = "Cancel",
        destructiveActionTitle: String = "Delete"
    ) {
        self.title = title
        self.message = message
        self.okActionTitle = okActionTitle
        self.cancelActionTitle = cancelActionTitle
        self.destructiveActionTitle = destructiveActionTitle
    }
}
