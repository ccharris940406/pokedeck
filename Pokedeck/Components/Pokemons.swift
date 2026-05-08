//
//  Pokemons.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 19/10/24.
//

import SwiftUI

struct Pokemons: View {
    @State private var loadingStage: LoadingStage = .idle
    @State private var errorMessage: String?
    @State private var pokemonsResponse: Response? = nil
    @State private var pokemonList: [PokemonShortInf] = []
    @State var nextUrl: String? = nil
    @State var prevUrl: String? = nil

    enum LoadingStage {
        case loading
        case idle
        case success
        case failure(PokemonApiQuery.PokemonApiError?)
    }
    func fetchPokemons(url: String? = nil) async throws {
        loadingStage = .loading
        do {
            if url != nil {
                pokemonsResponse = try await PokemonApiQuery().getPokemonData(
                    url!)
            } else {
                pokemonsResponse = try await PokemonApiQuery().getPokemons()
            }

            nextUrl = pokemonsResponse?.next ?? nil
            prevUrl = pokemonsResponse?.previous ?? nil
            pokemonList = pokemonsResponse?.results ?? []
            loadingStage = .success
        } catch {
            loadingStage = .failure(error as? PokemonApiQuery.PokemonApiError)
            errorMessage = error.localizedDescription
        }

    }

    var body: some View {
            VStack {
                switch loadingStage {
                case .loading:
                    ForEach(1...5, id: \.self) {
                        index in
                        HStack {
                            Rectangle()
                                .frame(width: 100)
                                .cornerRadius(20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(.appBackground).opacity(0.3)
                            Spacer()
                            ProgressView()
                                .controlSize(.extraLarge)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.appPrimary)
                        .cornerRadius(20)
                    }
                case .idle:
                    EmptyView()
                case .success:
                    ForEach(pokemonList, id: \.url) { pokemon in
                        PokemonListItem(
                            pokemonName: pokemon.name, pokemonUrl: pokemon.url)
                    }
                case .failure(_):
                    Spacer()
                    Text(errorMessage ?? "Error al cargar los Pokémon")
                        .foregroundColor(.red)
                    Button {
                        Task {
                            try await self.fetchPokemons()
                        }
                    } label: {
                        Image(systemName: "arrow.down.circle")
                            .font(.title)
                    }
                    Spacer()
                }
                PaginationStack(
                    fetchFunction: self.fetchPokemons, prevUrl: $prevUrl,
                    nextUrl: $nextUrl)
            }
            .padding()
            .onAppear {
                Task {
                    do {
                        try await fetchPokemons()
                    } catch {
                        loadingStage = .failure(nil)
                        errorMessage = "Ocurrió un error al cargar los Pokémon"
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.appBackground)
        }

    }

#Preview {
    Pokemons()
}
