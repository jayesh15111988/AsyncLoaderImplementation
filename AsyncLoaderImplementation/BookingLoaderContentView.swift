//
//  BookingLoaderContentView.swift
//  AsyncLoaderImplementation
//
//  Created by Jayesh Kawli on 22/02/2023.
//

import SwiftUI

struct BookingLoaderContentView: View {

    class ViewModel {
        let title: String
        let subtitle: String

        init(title: String, subtitle: String) {
            self.title = title
            self.subtitle = subtitle
        }
    }

    let viewModel: ViewModel

    var body: some View {
        HStack(spacing: 16) {
            ProgressView()
            VStack(spacing: 16) {
                Text(viewModel.title)
                Text(viewModel.subtitle)
            }
        }.padding().background(Color.yellow)
    }
}

struct BookingLoaderContentView_Previews: PreviewProvider {

    static var previews: some View {
        BookingLoaderContentView(viewModel: .init(title: "something", subtitle: "Anything"))
    }
}
