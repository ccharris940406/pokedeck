//
//  PokemonListItem.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 23/10/24.
//

import SwiftUI

struct PokemonListItem: View {

    enum LoadingStage {
        case loading
        case idle
        case success(Pokemon)
        case failure(PokemonApiQuery.PokemonApiError?)
    }
    let pokemonName: String
    let pokemonUrl: String
    @State var showDetails: Bool = false
    @State var pokemon: Pokemon?
    @State var pokemonColor: PokemonColor?
    @State var loadingStage: LoadingStage = .idle
    @State var errorMessage: String?

    var body: some View {
        HStack {
            switch loadingStage {
            case .loading:
                HStack {
                    Rectangle()
                        .frame(width: 100)
                        .cornerRadius(20)
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(.appBackground).opacity(0.3)
                    Spacer()
                    ProgressView {
                        Text(pokemonName)
                    }
                    .controlSize(.extraLarge)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.appPrimary)
                .cornerRadius(20)

            case .idle:
                EmptyView()
            case .success(let pokemon):
                Button {
                    showDetails.toggle()
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: pokemon.sprites.frontDefault)) {
                            image in
                            image
                                .resizable()
                                .frame(width: 100)
                                .aspectRatio(contentMode: .fit)
                                .background(
                                    Color.color(from: pokemonColor?.name ?? "")
                                        ?? .appPrimary
                                )
                                .cornerRadius(20)
                        } placeholder: {
                            Rectangle()
                                .frame(width: 100)
                                .cornerRadius(20)
                                .foregroundStyle(.appBackground).opacity(0.3)
                                .aspectRatio(contentMode: .fill)
                        }
                        Spacer()
                            .border(.white)
                        Text(pokemon.name.capitalized)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(.black)
                    .sheet(isPresented: $showDetails) {
                        PokemonCard(pokemon: pokemon, color: pokemonColor!)
                    }
                }

                
            case .failure(_):
                Text(errorMessage ?? "Error al cargar pokemon")
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .onAppear {
            Task {
                loadingStage = .loading
                do {
                    let response: Pokemon = try await PokemonApiQuery()
                        .getPokemonData(
                            pokemonUrl)
                    let specieResponse: PokemonSpecieInfo =
                        try await PokemonApiQuery().getPokemonData(
                            response.species.url)
                    pokemonColor = specieResponse.color
                    loadingStage = .success(response)
                } catch {

                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //        .background(Color.color(from: pokemonColor?.name ?? "" ) ?? .appPrimary)
        .background(.appPrimary)
        .cornerRadius(20)

    }

}

#Preview {
    PokemonListItem(
        pokemonName: "name", pokemonUrl: "https://pokeapi.co/api/v2/pokemon/1/")
}
