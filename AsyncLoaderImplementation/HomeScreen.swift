//
//  HomeScreen.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 22/02/2023.
//

import SwiftUI

struct HomeScreen: View {

    @State private var showCheckoutScreen = false

    var body: some View {
        Button {
            showCheckoutScreen = true
        } label: {
            Text("Go to checkout")
        }.sheet(isPresented: $showCheckoutScreen) {
            CheckoutScreen(showCheckoutScreen: $showCheckoutScreen)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
