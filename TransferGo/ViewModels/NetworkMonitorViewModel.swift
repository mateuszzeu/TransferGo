//
//  NetworkMonitorViewModel.swift
//  TransferGo
//
//  Created by MAT on 25/09/2025.
//
import Foundation
import Combine

@MainActor
class NetworkMonitorViewModel: ObservableObject {
    private let monitor = NetworkMonitor()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var shouldShowBanner: Bool = false
    
    init() {
        monitor.$isConnected
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                if !isConnected {
                    self.shouldShowBanner = true
                } else {
                    self.shouldShowBanner = false
                }
            }
            .store(in: &cancellables)
    }
    
    func dismissBanner() {
        shouldShowBanner = false
    }
}
