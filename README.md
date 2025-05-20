# 🛍️ Store - A Modern E-Commerce iOS App  
Built with **Swift** • **SwiftUI** • **MVVM** • **Combine** • **Dependency Injection**

A sleek and performant iOS e-commerce app built using modern Apple technologies. Showcases a fully functional product listing interface with simulated in-app purchases powered by **StoreKit**.

![Main](https://github.com/user-attachments/assets/2247e7b4-7a26-46ce-9b90-b3924bd7b4bf)

---

## 🚀 Features

- **🛒 Product Listing**  
  Fetches products from a mock API and displays them in a beautifully adaptive grid layout.

- **🛍️ StoreKit Integration (Mock)
Simulates in-app purchases using a custom PurchaseManager, mimicking StoreKit behavior alongside API data.

⚠️ Note: StoreKit functionality is mocked for demonstration purposes, as the project was developed without an active Apple Developer certificate.

- **📦 Modular Network Monitoring**  
  Integrated a **custom `NetworkMonitorKit` Swift package** for reusable, observable network status tracking across the app.

- **🧩 Dependency Injection**  
  Clean and testable code architecture with injected API services for better flexibility and unit testing.

- **📱 MVVM Architecture**  
  Strong separation of concerns — the ViewModel handles logic and state while SwiftUI views remain declarative and reactive.

- **⚡ Combine Framework**  
  Manages API calls, user input, and network status changes using reactive publishers.

- **🔍 Search & Filter**  
  Real-time filtering with SwiftUI's `.searchable` modifier and `@Published` bindings.

- **🌐 Offline Detection & Recovery**  
  Live network state monitoring. Automatically re-fetches data once the internet connection is restored.

- **🌙 Dark Mode Supported**  
  Full support for system-wide light/dark appearance settings using SwiftUI theming.

- **🏗️ Pure SwiftUI**  
  Built entirely in Swift, using native SwiftUI components for maintainability and modern UI responsiveness.

---

## 🧠 Architecture Overview

### 🧩 Model  
Represents product data fetched from the API.

### 🧠 ViewModel  
`ProductListViewModel`:
- Fetches product data
- Loads StoreKit products
- Handles purchases
- Filters based on search
- Tracks network status

### 👁 View  
SwiftUI views (like `ProductListView`) observe the ViewModel, display the UI, and respond to actions like search and pull-to-refresh.

### ⚙️ Services  
- `ApiService`: Fetches product data from API  
- `PurchaseManager`: Wraps mock StoreKit logic  
- `NetworkMonitor`: Provided by the custom `NetworkMonitorKit` framework for connectivity awareness

---

![Mainx](https://github.com/user-attachments/assets/3b09a557-3bec-4c92-9f0f-f72be0466ef5)

---

## 🛠️ How to Run

1. Clone this repo.
2. Open `ECommerceDemo.xcodeproj` in **Xcode 14+**
3. Build and run on an iOS 15+ simulator or device.
4. Pull to refresh product listings.
5. Toggle network connection to simulate offline mode.
6. Try purchasing a product to test mock StoreKit flow.

---

## 📦 Dependencies

- Uses native Apple frameworks:
  - **Combine** for reactive streams
  - **Swift Concurrency** (async/await)
- ✅ **No third-party dependencies** — lightweight and pure Swift
- ✅ **Custom `NetworkMonitorKit`** framework included for reusable network logic

---

![MainSS](https://github.com/user-attachments/assets/c50310a5-9bdb-4b66-9879-77ca0241e582)
