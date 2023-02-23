//
//  BookingProcessor.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 22/02/2023.
//

import Foundation
import Combine

class BookingProcessor: ObservableObject {

    enum BookingProcessorState {
        case idle
        case starting
        case running(BookingResponse)
        case error
        case completed(BookingResponse)
    }

    private let defaultDelay = UInt64(1_000_000_000)
    private let smallDelay = UInt64(500_000_000)

    var stateSubject: CurrentValueSubject<BookingProcessorState, Never>
    let statePublisher: AnyPublisher<BookingProcessorState, Never>

    var pollingCount = 0

    init() {
        stateSubject = CurrentValueSubject(.idle)
        statePublisher = stateSubject.eraseToAnyPublisher()
    }

    func startBooking() async {
        guard case .idle = stateSubject.value else {
            return
        }

        do {
            stateSubject.send(.starting)
            let bookingResponse = try await sendInitialBookingRequest()
            try await sendPollingBookingRequest(with: bookingResponse)
        } catch {
            stateSubject.send(.error)
        }
    }

    func sendInitialBookingRequest() async throws -> BookingResponse {
        try await Task.sleep(nanoseconds: defaultDelay)
        return BookingResponse(id: "100", status: .processing)
    }

    func sendPollingBookingRequest(with booking: BookingResponse) async throws {
        var bookingResponse = booking
        while bookingResponse.status != .completed {
            stateSubject.send(.running(bookingResponse))
            bookingResponse = try await performBookingPolling(with: booking.id)
            try await Task.sleep(nanoseconds: defaultDelay)
        }

        // Send the error to test failure scenario
        //stateSubject.send(.error)
        stateSubject.send(.completed(bookingResponse))
    }

    func performBookingPolling(with bookingId: String) async throws -> BookingResponse {
        try await Task.sleep(nanoseconds: smallDelay)

        let bookingStatus: BookingResponse.BookingStatus = pollingCount > 2 ? .completed : .processing
        pollingCount += 1

        return BookingResponse(id: "\(pollingCount * 100)", status: bookingStatus)
    }
}


