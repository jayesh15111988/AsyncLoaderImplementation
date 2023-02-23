//
//  BookingResponse.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 22/02/2023.
//

import Foundation

struct BookingResponse: Decodable {

    enum BookingStatus: Decodable {
        case processing
        case completed
        case failed
    }

    let id: String
    let status: BookingStatus
}
