//
//  ProductCard.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 19/05/25.
//

import SwiftUI

struct ProductCard: View {
    @Environment(\.colorScheme) var colorScheme
    var product: Product

    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Background Image
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 160)
                        .padding(.top, 12)
                        .padding(.horizontal, 12)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .dark ? .black : .white)
            .cornerRadius(20)
            
            // Text Overlay at Bottom
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline).bold()
                    .lineLimit(2)
                    .foregroundColor(.primary)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
            )
            .padding(8)
        }
        .frame(width: 180, height: 250)
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}


#Preview {
    ProductCard(product: Product(
        id: 1,
        title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest.",
        image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
    ))
}
