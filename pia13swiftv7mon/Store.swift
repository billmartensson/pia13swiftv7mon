//
//  Store.swift
//  pia13swiftv7mon
//
//  Created by BillU on 2024-12-16.
//

import Foundation
import StoreKit

@Observable class Store {
    var products: [Product] = []
    var activeTransactions: Set<StoreKit.Transaction> = []
    
    private var updates: Task<Void, Never>?
    
    
    var goldcoinProduct : Product?
    var premiumProduct : Product?

    init() {
        updates = Task {
            for await update in StoreKit.Transaction.updates {
                print("TRANSACTION UPDATE")
                if let transaction = try? update.payloadValue {
                    print(transaction.productID)
                    await fetchActiveTransactions()
                    await transaction.finish()
                }
            }
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    
    
    func fetchProducts() async {
        do {
            products = try await Product.products(
                for: [
                    "pia13goldcoin", "pia13premium"
                ]
            )
            
            for prod in products {
                if prod.id == "pia13goldcoin" {
                    goldcoinProduct = prod
                }
                if prod.id == "pia13premium" {
                    premiumProduct = prod
                }
            }
            
        } catch {
            products = []
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            print("BUY OK")
            if let transaction = try? verificationResult.payloadValue {
                print("TRANSACTION")
                activeTransactions.insert(transaction)
                await transaction.finish()
            }
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    func fetchActiveTransactions() async {
        var activeTransactions: Set<StoreKit.Transaction> = []
        
        for await entitlement in StoreKit.Transaction.currentEntitlements {
            if let transaction = try? entitlement.payloadValue {
                activeTransactions.insert(transaction)
            }
        }
        
        self.activeTransactions = activeTransactions
    }
}
