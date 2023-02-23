//
//  BookingLoader.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 21/02/2023.
//

import SwiftUI

struct BookingLoader: View {

    var bookingLoaderContentViewModel: BookingLoaderContentView.ViewModel

    var body: some View {
        VStack {
            Color.red.opacity(0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    BookingLoaderContentView(viewModel: bookingLoaderContentViewModel)
                )
        }
    }
}
