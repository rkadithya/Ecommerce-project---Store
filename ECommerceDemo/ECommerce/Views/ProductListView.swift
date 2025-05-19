//
//  ProductListView.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 18/05/25.
//

import SwiftUI
import StoreKit

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel(apiService: ApiService.shared)
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Loading products...")
                        .padding(.top, 40)
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .refreshable {
                viewModel.fetchProducts()
            }
            .navigationTitle("Products")
            .searchable(text: $viewModel.searchText, prompt: "Search products")
            .alert("No Internet Connection", isPresented: $viewModel.showNoNetworkAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "Please check your connection and try again.")
            }
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}

#Preview {
    ProductListView()
}
