//
//  Product.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 18/05/25.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
}
