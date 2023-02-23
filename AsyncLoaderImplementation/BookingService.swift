//
//  BookingService.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 22/02/2023.
//

import SwiftUI

final class BookingService {

    private var bookingProcessor: BookingProcessor?

    func book() -> BookingProcessor {

       let bookingProcessor = BookingProcessor()

        Task {
            await bookingProcessor.startBooking()
        }

        return bookingProcessor
    }
}
