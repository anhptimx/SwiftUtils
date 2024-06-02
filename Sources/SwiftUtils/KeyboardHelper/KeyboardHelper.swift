//
//  KeyboardHelper.swift
//
//
//  Created by IMX on 2/6/24.
//

import UIKit
import Combine

public class KeyboardHelper {
    static public let shared = KeyboardHelper()

    private init() {
        setupNotification()
    }

    private var cancellables: Set<AnyCancellable> = []
    private let subject = PassthroughSubject<KeyboardEvent, Never>()

    public enum Animation {
        case keyboardWillShow
        case keyboardWillHide
    }

    public struct KeyboardEvent {
        let animation: Animation
        let keyboardFrame: CGRect
        let duration: Double
        let notification: Notification
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    private func setupNotification() {
        cancellables.removeAll()
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                self?.handle(animation: .keyboardWillShow, notification: notification)
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] notification in
                self?.handle(animation: .keyboardWillHide, notification: notification)
            }
            .store(in: &cancellables)
    }

    private func handle(animation: Animation, notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        let event = KeyboardEvent(animation: animation, keyboardFrame: keyboardFrame, duration: duration, notification: notification)
        subject.send(event)
    }

    public func observeKeyboardEvents(handler: @escaping (KeyboardEvent) -> Void) {
        subject.sink { event in
            handler(event)
        }.store(in: &cancellables)
    }
}
