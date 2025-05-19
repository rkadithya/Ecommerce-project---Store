//
//  StoreManager.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 18/05/25.
//

import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var products: [StoreKit.Product] = []
    @Published var purchasedProducts: [StoreKit.Product] = []
    @Published var purchaseError: Error?

    func purchase(_ product: StoreKit.Product) async {
        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updatePurchasedProducts()
            case .userCancelled:
                print("User cancelled the purchase.")
            case .pending:
                print("Purchase pending.")
            @unknown default:
                print("Unknown purchase result.")
            }
        } catch {
            print("Purchase error: \(error)")
            purchaseError = error
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }

    func updatePurchasedProducts() async {
        var purchased = [StoreKit.Product]()
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if let product = products.first(where: { $0.id == transaction.productID }) {
                    purchased.append(product)
                }
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
        purchasedProducts = purchased
    }
}
