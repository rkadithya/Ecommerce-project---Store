//
//  PurchaseManager.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 18/05/25.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    @Published var storeKitProducts: [StoreKit.Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var error: Error?

    static let shared = PurchaseManager()
    let productIDs = [
        "com.mockapp.product1",
        "com.mockapp.product2",
        "com.mockapp.product3",
        "com.mockapp.product4",
        "com.mockapp.product5",
        "com.mockapp.product6",
        "com.mockapp.product7",
        "com.mockapp.product8",
        "com.mockapp.product9",
        "com.mockapp.product10",
        "com.mockapp.product11",
        "com.mockapp.product12",
        "com.mockapp.product13",
        "com.mockapp.product14",
        "com.mockapp.product15",
        "com.mockapp.product16",
        "com.mockapp.product17",
        "com.mockapp.product18",
        "com.mockapp.product19"

    ]

    func loadProducts() async {
        do {
            storeKitProducts = try await StoreKit.Product.products(for: productIDs)
            await updatePurchasedProducts()
        } catch {
            print("Error loading products: \(error)")
            self.error = error
        }
    }

    func purchase(_ product: StoreKit.Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                purchasedProductIDs.insert(transaction.productID)
            case .userCancelled:
                print("User cancelled.")
            case .pending:
                print("Purchase pending.")
            @unknown default:
                break
            }
        } catch {
            print("Purchase error: \(error)")
            self.error = error
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error): throw error
        case .verified(let value): return value
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                purchasedProductIDs.insert(transaction.productID)
            } catch {
                print("Failed verification: \(error)")
            }
        }
    }

    func isPurchased(_ storeKitProduct: StoreKit.Product) -> Bool {
        return purchasedProductIDs.contains(storeKitProduct.id)
    }
}
