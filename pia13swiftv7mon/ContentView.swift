//
//  ContentView.swift
//  pia13swiftv7mon
//
//  Created by BillU on 2024-12-16.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @State private var showBuy = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button(action: {
                showBuy = true
            }) {
                Text("Buy")
            }
        }
        .padding()
        .sheet(isPresented: $showBuy) {
            BuyView()
        }
    }
}

#Preview {
    ContentView()
}
