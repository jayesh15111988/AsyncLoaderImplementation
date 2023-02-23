//
//  CheckoutScreenViewModel.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 21/02/2023.
//

import Foundation
import Combine

class CheckoutScreenViewModel: ObservableObject {

    enum LoadingState {
        case idle
        case loading(BookingLoaderContentView.ViewModel)
        case completed(BookingLoaderContentView.ViewModel)
        case error
    }

    @Published var loadingState: LoadingState = .idle

    @Published var showAlertMessage = true

    let bookingService: BookingService
    var bookingProcessor: BookingProcessor?
    var bookingStateCancellable: AnyCancellable?

    init(bookingService: BookingService) {
        self.bookingService = bookingService
    }

    func bookTicket() {

        guard case .idle = loadingState else {
            return
        }

        loadingState = .loading(.init(title: "Initiating booking", subtitle: "Booking Started"))

        let bookingProcessor = bookingService.book()

        self.bookingProcessor = bookingProcessor

        bookingStateCancellable = bookingProcessor.statePublisher.receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            if case .failure = completion {
                self?.loadingState = .error
                self?.showAlertMessage = true
            }
        }, receiveValue: { bookingProcessorState in
            self.loadingState = self.convertToViewLoadingState(from: bookingProcessorState)
        })
    }

    private func convertToViewLoadingState(from bookingProcessorState: BookingProcessor.BookingProcessorState) -> LoadingState {
        switch bookingProcessorState {
        case .idle:
            return .idle
        case .starting:
            return .loading(.init(title: "Booking Tickets", subtitle: "Starting the booking"))
        case .running(let bookingResponse):
            return .loading(.init(title: "Processing Request", subtitle: "Your booking id is \(bookingResponse.id). Please do not leave this page until processing is complete"))
        case .error:
            self.showAlertMessage = true
            return .error
        case .completed(let bookingResponse):
            return .completed(.init(title: "Booking completed", subtitle: "Booking completed with booking confirmation id \(bookingResponse.id)"))
        }
    }
    
}
