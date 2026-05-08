//
//  PaginationStack.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 23/10/24.
//

import SwiftUI

struct PaginationStack: View {

    var fetchFunction: (String?) async throws -> Void
    @Binding var prevUrl: String?
    @Binding var nextUrl: String?

    var body: some View {
        HStack {
            PaginationButton(
                buttonType: .previous, fetchFunction: self.fetchFunction,
                url: $prevUrl)
            Spacer()
            PaginationButton(
                buttonType: .next, fetchFunction: self.fetchFunction,
                url: $nextUrl)
        }
        .frame(height: 70)
        .padding()
    }
}

#Preview {
    PaginationStack(
        fetchFunction: { _ in }, prevUrl: .constant("hello"),
        nextUrl: .constant("mundo"))
}
