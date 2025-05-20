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
    @Published private(set) var purchasedProductIDs: Set<String> = []
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

    @MainActor
    func purchase(_ product: StoreKit.Product) async -> Bool {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    print("✅ Purchase successful: \(transaction.productID)")
                    await transaction.finish()
                    
                    // ✅ Trigger refresh
                    await loadPurchasedProducts() 
                    
                    return true
                case .unverified(_, let error):
                    print("⚠️ Unverified purchase: \(error.localizedDescription)")
                    return false
                }
            case .userCancelled:
                print("❌ Purchase cancelled by user")
                return false
            case .pending:
                print("⏳ Purchase pending approval")
                return false
            @unknown default:
                return false
            }
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
            return false
        }
    }


    @MainActor
    func loadPurchasedProducts() async {
        var purchased = Set<String>()

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchased.insert(transaction.productID)
            }
        }

        purchasedProductIDs = purchased
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

    func isPurchased(_ product : StoreKit.Product) -> Bool {
        purchasedProductIDs.contains(product.id)
    }

}
