//
//  PaginationButton.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 23/10/24.
//

import SwiftUI

struct PaginationButton: View {
    let buttonType: ButtonType
    var fetchFunction: (String) async throws -> Void
    @Binding var url: String?
    var body: some View {
        Button {
            Task {
                do {
                    if url != nil {
                        try await fetchFunction(url! )
                    }
                }catch {
                    print(error)
                }
            }
            
        } label: {
            Image(systemName: buttonType.getProps().iconString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(url == nil ? .gray : buttonType.getProps().color)
                .accessibilityValue(buttonType.getProps().name)


        }
        .disabled(url == nil)

    }
}


enum ButtonType {
    case previous
    case next
    
    func getProps() -> (iconString: String, color: Color, name: String)  {
        switch self {
        case .previous:
            return ("chevron.left.square.fill", .appSecundary, "Previous Page")
        case .next:
            return ("chevron.right.square.fill", .appPrimary, "Next Page")
        }
    }
    
}

#Preview {
    PaginationButton(buttonType: .previous, fetchFunction: {_ in }, url: .constant("hola"))
}
