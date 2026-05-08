//
//  Untitled.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 24/10/24.
//

import Foundation
import SwiftUICore

extension Color {
    static let pokemonColors: [String: Color] = [
        "red": .red,
        "blue": .blue,
        "yellow": .yellow,
        "green": .green,
        "purple": .purple,
        "orange": .orange,
        "pink": .pink,
        "brown": .brown,
        "gray": .gray,
        "black": .black,
        "white": .white,
]
    static func color (from name: String) -> Color? {
        pokemonColors[name.lowercased()]
    }
}
