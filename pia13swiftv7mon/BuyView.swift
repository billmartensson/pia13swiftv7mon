//
//  BuyView.swift
//  pia13swiftv7mon
//
//  Created by BillU on 2024-12-16.
//

import SwiftUI
import StoreKit

struct BuyView: View {
        
    @State private var store = Store()

    
    var body: some View {
        VStack {
            
            if store.goldcoinProduct != nil {
                Text(store.goldcoinProduct!.displayName)
                Text(store.goldcoinProduct!.displayPrice)
                Button(action: {
                    Task {
                        do {
                            try await store.purchase(store.goldcoinProduct!)
                        } catch {
                        }

                    }
                }) {
                    Text("BUY!!!")
                }
            }
            
            
            
            ProductView(id: "pia13goldcoin")
                .onInAppPurchaseStart { product in
                    print("User has started buying \(product.id)")
                }
                .onInAppPurchaseCompletion { product, result in
                    if case .success(.success(let transaction)) = result {
                        print("Purchased successfully: \(transaction.signedDate)")
                    } else {
                        print("Something else happened")
                    }
                }
            
            ProductView(id: "pia13premium") {
                    Image(systemName: "crown")
                }
                .productViewStyle(.compact)
                .onInAppPurchaseStart { product in
                    print("User has started buying \(product.id)")
                }
                .onInAppPurchaseCompletion { product, result in
                    if case .success(.success(let transaction)) = result {
                        print("Purchased successfully: \(transaction.signedDate)")
                    } else {
                        print("Something else happened")
                    }
                }
            
        }
        .task {
            await store.fetchProducts()
        }
    }
    
    
}

#Preview {
    BuyView()
}
