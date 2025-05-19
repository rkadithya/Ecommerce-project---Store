//
//  ProductDetailView.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 18/05/25.
//

import SwiftUI
import StoreKit

struct ProductDetailView: View {
    let product: Product
    @ObservedObject var purchaseManager = PurchaseManager.shared
    @State private var showConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Product Image
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .frame(height: 250)
                        ProgressView()
                    }
                }
                .frame(height: 250)
                .padding(.horizontal)

                // Product Info
                VStack( alignment: .center, spacing: 12) {
                    Text(product.title)
                        .font(.title2)
                        .multilineTextAlignment(.center)

                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title3)
                        .foregroundColor(.green)

                    Text(product.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 4)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 2)
                .padding(.horizontal)

                // Purchase Info
                VStack(spacing: 10) {
               

                    if let storeKitProduct = purchaseManager.storeKitProducts.first(where: {
                        $0.id == "com.mockapp.product\(product.id)"
                    }) {
                        if purchaseManager.isPurchased(storeKitProduct) {
                            Label("Already Purchased", systemImage: "checkmark.seal.fill")
                                .foregroundColor(.green)
                                .font(.subheadline)
                        } else {
                            Button("Buy for \(storeKitProduct.displayPrice)") {
                                Task {
                                    await purchaseManager.purchase(storeKitProduct)
                                    showConfirmation = true
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .alert("Purchase Successful!", isPresented: $showConfirmation) {
                                Button("OK", role: .cancel) {}
                            }
                        }
                    } else {
                        Label("Not available for purchase", systemImage: "xmark.octagon.fill")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
                .padding(.top, 10)
            }
            .padding(.vertical)
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await purchaseManager.loadProducts()
            }
        }
    }
}

//For testing purpose
#Preview {
    ProductDetailView(product: Product(id: 1, title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops", price: 109.95, description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday", image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"))
}
