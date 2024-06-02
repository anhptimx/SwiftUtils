//
//  AlertManager.swift
//
//
//  Created by IMX on 3/6/24.
//

import UIKit

open class AlertManager {
    private init() {}
    public static let shared: AlertManager = AlertManager()

    private lazy var defaultConfig: AlertManagerConfiguration = {
        return AlertManagerConfiguration()
    }()

    public func configure(configuration: AlertManagerConfiguration) {
        self.defaultConfig = configuration
    }

    public func show(title: String? = nil,
                     message: String? = nil,
                     from controller: UIViewController? = nil,
                     completion: (() -> Void)? = nil) {
        let presentingController = controller ?? SwiftUtils.topViewController()
        guard let presentingController = presentingController else {
            print("Error: No view controller to present alert from.")
            return
        }

        let alertController = UIAlertController(
            title: title ?? defaultConfig.title,
            message: message ?? defaultConfig.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: defaultConfig.okActionTitle,
            style: .default
        ) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        presentingController.present(alertController, animated: true, completion: nil)
    }

    public func customShow(title: String? = nil,
                           message: String? = nil,
                           actions: [(title: String, style: UIAlertAction.Style, handler: (() -> Void)?)]? = nil,
                           from controller: UIViewController? = nil) {
        let presentingController = controller ?? SwiftUtils.topViewController()
        guard let presentingController = presentingController else {
            print("Error: No view controller to present alert from.")
            return
        }

        let alertController = UIAlertController(
            title: title ?? defaultConfig.title,
            message: message ?? defaultConfig.message,
            preferredStyle: .alert
        )

        let defaultActions = actions ?? [(title: defaultConfig.okActionTitle, style: .default, handler: nil)]

        for action in defaultActions {
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            }
            alertController.addAction(alertAction)
        }

        presentingController.present(alertController, animated: true, completion: nil)
    }
}
