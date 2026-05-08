//
//  PokemonCard.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 25/10/24.
//

import Charts
import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    let color: PokemonColor

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: pokemon.sprites.frontDefault)) {
                image
                in
                image
                    .resizable()
                    .background(Color.color(from: color.name))
                    .cornerRadius(20)
                    .shadow(radius: 20)
            } placeholder: {
                Rectangle()
                    .foregroundStyle(
                        Color.color(from: color.name) ?? .appSecundary
                    )
                    .cornerRadius(20)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(contentMode: .fit)
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .foregroundStyle(.black)
            Text("Specie: \(pokemon.species.name)")
                .font(.title3)
            HStack {
                Spacer()
                Label("\(pokemon.weight) kg", systemImage: "scalemass.fill")
                Spacer()
                Label("\(pokemon.height) m", systemImage: "arrow.up.and.down")
                Spacer()
            }
            .font(.title3)
            .padding()
            Spacer()
            StatsSectorChart(pokemon: pokemon)
        }
        .padding()
        .foregroundStyle(.black)
        .background(.appBackground)
    }
}

#Preview {
    let pokemon = Pokemon(
        id: 1, name: "Bulbasaur", height: 60, weight: 70,
        species: PokemonSpecie(name: "Bulbasaur", url: "an url"),
        sprites: PokemonSprites(frontDefault: "an url"),
        stats: [
            StatItem(baseStat: 60, stat: StatItem.Stat(name: "HP")),
            StatItem(baseStat: 60, stat: StatItem.Stat(name: "attack")),
            StatItem(baseStat: 60, stat: StatItem.Stat(name: "other")),
        ])
    let pokemonColor = PokemonColor(name: "red", url: "sad")
    PokemonCard(pokemon: pokemon, color: pokemonColor)
}

struct StatsSectorChart: View {
    
    @State private var selectedAngle: Double?
    let pokemonStats: [StatItem]
    private let statsRange: [(statName: String, range: Range<Double>)]
    private let totalStats: Int
    
    private var titleView: some View {
        VStack {
            Text(selectedStat?.stat.name ?? "Stats")
                .font(.title)
            Text((selectedStat?.baseStat.formatted() ?? totalStats.formatted()))
                .font(.callout)
        }
    }
    
    init(pokemon: Pokemon) {
        self.pokemonStats = pokemon.stats
        var total = 0
        
        statsRange = pokemonStats.map {
            let newTotal = total + $0.baseStat
            let result = (statName: $0.stat.name, range: Double(total)..<Double(newTotal))
            total = newTotal
            return result
        }
        self.totalStats = total
    }
    
    var selectedStat: StatItem? {
        guard let selectedAngle else { return nil }
        if let selected = statsRange.firstIndex(where: { $0.range.contains(selectedAngle)}) {
            return pokemonStats[selected]
        }
        return nil
    }
    
    var body: some View {
        Chart(pokemonStats, id: \.stat.name) { pokemonStat in
            SectorMark(
                angle: .value("Value", pokemonStat.baseStat),
                innerRadius: .ratio(pokemonStat.stat.name == selectedStat?.stat.name ? 0.7 : 0.9), outerRadius: .inset(10),
                angularInset: 1
            )
            .cornerRadius(20)
            .foregroundStyle(by: .value("Stat", pokemonStat.stat.name))
            .opacity(pokemonStat.stat.name == selectedStat?.stat.name ?  1 : 0.5)
        }
        .chartLegend(.hidden)
        .chartAngleSelection(value: $selectedAngle)
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 16)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    titleView
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }
}
