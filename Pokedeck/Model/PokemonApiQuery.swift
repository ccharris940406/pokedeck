//
//  Untitled.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 22/10/24.
//

import Foundation

let allPokemonsBaseUrl: String =
    "https://pokeapi.co/api/v2/pokemon?limit=5&offset=0"

class PokemonApiQuery {

    enum PokemonApiError: Error {
        case invalidResponse
        case invalidData
        case invalidUrl

        func localizedDescription() -> String {
            switch self {
            case .invalidResponse:
                return "Invalid response from the Pokemon API."
            case .invalidData:
                return "Invalid data from the Pokemon API."
            case .invalidUrl:
                return "Invalid URL for the Pokemon API."
            }
        }
    }

    func getPokemonData<T: Decodable>(_ urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw PokemonApiError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw PokemonApiError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw PokemonApiError.invalidData
        }

    }

    func getPokemons(_ urlString: String = allPokemonsBaseUrl) async throws
        -> Response
    {
        guard let url = URL(string: urlString) else {
            throw PokemonApiError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw PokemonApiError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw PokemonApiError.invalidData
        }

    }

}
