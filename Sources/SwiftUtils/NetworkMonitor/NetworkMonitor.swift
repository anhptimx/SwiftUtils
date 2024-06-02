//
//  NetworkMonitor.swift
//  
//
//  Created by IMX on 3/6/24.
//

import Network
import Combine

public class NetworkMonitor {
    public static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor

    public let networkSubject = CurrentValueSubject<NWPath.Status, Never>(.unsatisfied)

    private init() {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            DispatchQueue.main.async {
                self.networkSubject.send(path.status)
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    deinit {
        stopMonitoring()
    }
}
