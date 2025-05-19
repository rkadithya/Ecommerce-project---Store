//
//  ProductListViewModel.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 18/05/25.
//


//
//  ProductListViewModel.swift
//  ECommerceDemo
//

import Foundation
import StoreKit
import Combine
import SwiftUI

@MainActor
class ProductListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products: [Product] = [] {
        didSet { filterProducts() }
    }
    @Published var storeKitProducts: [StoreKit.Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showNoNetworkAlert = false
    @Published var searchText: String = "" {
        didSet { filterProducts() }
    }
    @Published var isConnected: Bool = true

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private var monitorCancellable: AnyCancellable?

    // MARK: - Dependencies
    let apiService: ApiServiceProtocol
    let purchaseManager = PurchaseManager()
    let networkManager = NetworkMonitor.shared

    // MARK: - Init
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
        
        monitorCancellable = networkManager.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.isConnected = status
                if status {
                    self?.errorMessage = nil
                    self?.showNoNetworkAlert = false
                    self?.fetchProducts() // Auto-fetch when online
                }
            }
    }

    // MARK: - Product Fetching
    func fetchProducts() {
        guard isConnected else {
            errorMessage = "No Internet Connection"
            showNoNetworkAlert = true
            return
        }

        isLoading = true
        apiService.fetchProducts()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false

                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                        self.showNoNetworkAlert = true
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.errorMessage = nil
                self.showNoNetworkAlert = false
                self.products = value

                Task {
                    await self.loadStoreKitProducts()
                }
            })
            .store(in: &cancellables)
    }

    // MARK: - StoreKit
    func loadStoreKitProducts() async {
        await purchaseManager.loadProducts()
        self.storeKitProducts = purchaseManager.storeKitProducts
    }

    func storeProduct(for apiProduct: Product) -> StoreKit.Product? {
        let expectedID = "com.mockapp.product\(apiProduct.id)"
        return storeKitProducts.first { $0.id == expectedID }
    }

    func buy(_ product: StoreKit.Product) async {
        await purchaseManager.purchase(product)
    }

    func isPurchased(_ product: StoreKit.Product) -> Bool {
        purchaseManager.isPurchased(product)
    }

    // MARK: - Filtering
    private func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
