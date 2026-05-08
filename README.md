# Pokedeck

A native iOS app for browsing and exploring Pokémon, built with SwiftUI and powered by [PokéAPI](https://pokeapi.co).

## Screenshots

> _Add screenshots here_

## Features

- Paginated Pokémon list (5 per page) with navigation controls
- Detail card per Pokémon: sprite, species, height, weight
- Interactive stats chart (donut chart) with tap-to-select
- Color-coded backgrounds derived from each Pokémon's species color
- Skeleton loading states and error handling with retry

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| Networking | URLSession + async/await |
| Charts | Apple Charts framework |
| Data source | PokéAPI v2 |
| Dependencies | None (zero third-party packages) |

## Requirements

- Xcode 16.0+
- iOS 18.0+

## Getting Started

```bash
open Pokedeck.xcodeproj
```

Select a simulator or device and press `Cmd+R`.

No additional setup needed — the app fetches data directly from `pokeapi.co`.

## Project Structure

```
Pokedeck/
├── PokedeckApp.swift          # App entry point
├── ContentView.swift          # Root view
├── Components/
│   ├── Pokemons.swift         # Main list screen with pagination
│   ├── PokemonListItem.swift  # Single row in the list
│   ├── PokemonCard.swift      # Detail sheet (sprite, stats, info)
│   ├── PaginationStack.swift  # Previous / Next navigation
│   └── PaginationButton.swift # Individual pagination button
├── Model/
│   ├── Pokemon.swift          # All Codable data models
│   └── PokemonApiQuery.swift  # API client (generic async fetch)
└── Utils/
    └── ColorConverter.swift   # Maps species color names to SwiftUI Color
```

## API Endpoints

| Purpose | Endpoint |
|---|---|
| Paginated list | `GET /api/v2/pokemon?limit=5&offset={n}` |
| Pokémon detail | `GET /api/v2/pokemon/{id}` |
| Species color | `GET /api/v2/pokemon-species/{id}` |

JSON responses are decoded using Swift's `convertFromSnakeCase` strategy.

## Architecture

The app follows a lightweight MVVM approach:

- **Views** own their state via `@State` and call the API layer directly
- **`PokemonApiQuery`** exposes a generic `getPokemonData<T: Decodable>()` method
- Loading states cycle through `idle → loading → success / failure`
- Pagination URLs (`next` / `previous`) are stored from each API response and passed to subsequent calls

## License

MIT
