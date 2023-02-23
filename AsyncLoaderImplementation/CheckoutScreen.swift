//
//  CheckoutScreen.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 21/02/2023.
//

import SwiftUI

struct CheckoutScreen: View {

    @StateObject var viewModel: CheckoutScreenViewModel

    @Binding var showCheckoutScreen: Bool

    @State private var showAlertMessage = false

    init(showCheckoutScreen: Binding<Bool>) {
        self._showCheckoutScreen = showCheckoutScreen
        self._viewModel = StateObject(wrappedValue: CheckoutScreenViewModel(bookingService: BookingService()))
    }

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                VStack {
                    Button {
                        showCheckoutScreen = false
                    } label: {
                        Text("Dismiss")
                    }

                    Button {
                        viewModel.bookTicket()
                    } label: {
                        Text("Tap to book")
                    }

                    Text("Long long test odnsnd sd asd as das d as ds das d asd as dsa \nasdasdasdasd\nasdasdasd\nasdasds")
                }

                switch viewModel.loadingState {
                case .idle:
                    Color.clear
                case .completed(let viewModel):
                    BookingLoader(bookingLoaderContentViewModel: viewModel).onAppear {
                        Task {
                            await dismissScreen()
                        }
                    }
                case .error:
                    Color.clear.alert(isPresented: $viewModel.showAlertMessage) {
                        Alert(
                            title: Text("Booking Failed"),
                            message: Text("Unfortunately, booking failed. Please try again"),
                            dismissButton: .default(Text("OK"), action: {
                            })
                        )
                    }
                case .loading(let bookingLoaderContentViewModel):
                    BookingLoader(bookingLoaderContentViewModel: bookingLoaderContentViewModel)
                }
            }
        }
    }

    func dismissScreen() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        showCheckoutScreen = false
    }
}

struct CheckoutScreen_Previews: PreviewProvider {

    @State static var showCheckoutScreen: Bool = false

    static var previews: some View {
        CheckoutScreen(showCheckoutScreen: $showCheckoutScreen)
    }
}
