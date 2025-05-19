# Ecommerce-project---Store | Swift | Swift UI
A modern iOS e-commerce app built with SwiftUI, showcasing a fully functional product listing with in-app purchases powered by StoreKit.


![Main](https://github.com/user-attachments/assets/2247e7b4-7a26-46ce-9b90-b3924bd7b4bf)

Features
🛒 Product Listing: Fetches products from a mock API and displays them in a beautifully adaptive grid layout.

🛍️ Mock StoreKit Integration: Simulates in-app purchases with a custom PurchaseManager, integrating real StoreKit products alongside API data.

🧩 Dependency Injection: Clean, testable code architecture with injected API services for flexibility and easier unit testing.

📱 MVVM Architecture: Robust separation of concerns using ViewModel to manage business logic and state, keeping SwiftUI views declarative and simple.

⚡ Combine Framework: Reactive programming to handle asynchronous API calls, network state changes, and user input seamlessly.

🔍 Search & Filter: Real-time product filtering with a searchable interface powered by @Published properties and SwiftUI’s .searchable.

🌐 Network Connectivity Monitoring: Live network status tracking with auto-fetch when the connection is restored, enhancing user experience during offline/online transitions.

🏗️ Swift & SwiftUI: Fully built in Swift with SwiftUI views for a modern, performant, and maintainable app.


Architecture Overview
Model: Product represents product data from the API.

ViewModel: ProductListViewModel handles fetching products, StoreKit product loading, purchase state, filtering, and network state.

View: ProductListView is a SwiftUI view displaying the UI, observing the ViewModel’s state and responding to user actions like pull-to-refresh and search.

Services: ApiService handles product fetching, while PurchaseManager wraps StoreKit interactions.

NetworkMonitor: Singleton observing network connectivity changes using NWPathMonitor with Combine publishers.


![Mainx](https://github.com/user-attachments/assets/3b09a557-3bec-4c92-9f0f-f72be0466ef5)


How to Run
Clone this repo.

Open ECommerceDemo.xcodeproj in Xcode 14+.

Build and run on iOS 15+ simulator or device.

Pull to refresh to fetch products, test offline mode by toggling network connection.

Try purchasing products to simulate StoreKit transactions.


Dependencies
Uses Combine and Swift Concurrency for reactive and async code.

No external dependencies — lightweight and pure Swift.


![MainSS](https://github.com/user-attachments/assets/c50310a5-9bdb-4b66-9879-77ca0241e582)

