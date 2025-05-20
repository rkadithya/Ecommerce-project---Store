//
//  ApiService.swift
//  ECommerceDemo
//
//  Created by RK Adithya on 19/05/25.
//

import Foundation
import Combine

protocol ApiServiceProtocol{
    func fetchProducts() -> AnyPublisher<[Product],Error>
}

class ApiService : ApiServiceProtocol{
    static let shared = ApiService()

    let url = "https://fakestoreapi.com/products"
    
    func fetchProducts() -> AnyPublisher<[Product], any Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Product].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
