//
//  SearchableModifier.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-27.
//

import SwiftUI
import Combine

struct Restaurant: Identifiable, Hashable {
    let id: String
    let title: String
    let cuisine: CuisineOption
}

enum CuisineOption: String {
    case american
    case italian
    case french
    case japanese
    case ukrainian
}

final class RestaurantManager {
    
    func getAll() async throws -> [Restaurant] {
        [
            Restaurant(id: "1", title: "Burger Shack", cuisine: .american),
            Restaurant(id: "2", title: "Pasta Palace", cuisine: .italian),
            Restaurant(id: "3", title: "Sushi Heaven", cuisine: .american),
            Restaurant(id: "4", title: "Puzata Hata", cuisine: .ukrainian),
            Restaurant(id: "5", title: "Frog House", cuisine: .french),
            Restaurant(id: "6", title: "Steak House", cuisine: .american)
        ]
    }
    
}

@MainActor
final class SearchableModifierViewModel: ObservableObject {
    
    @Published private(set) var allRestaurants: [Restaurant] = []
    @Published private(set) var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = ""
    @Published var selection: SearchScope = .all
    @Published private(set) var allScopeOptions: [SearchScope] = []
    
    let manager = RestaurantManager()
    var cancellables: Set<AnyCancellable> = []
    
    var isSearching: Bool {
        !searchText.isEmpty || selection != .all
    }
    
    var showSuggestions: Bool {
        searchText.count < 3
    }
    
    enum SearchScope: Hashable {
        case all
        case cuisine(option: CuisineOption)
        
        var title: String {
            switch self {
            case .all:
                return "All"
            case .cuisine(option: let option):
                return option.rawValue.capitalized
            }
        }
    }
    
    init() {
        searchRestaurants()
    }
    
    private func searchRestaurants() {
        $searchText
            .combineLatest($selection)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] (text, option) in
                self?.filterRestaurants(text, option: option)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(_ text: String, option: SearchScope) {
        // !!!!!!!!!!!!!!!
        guard !text.isEmpty else {
            if option != .all {
                filteredRestaurants = allRestaurants.filter({ $0.cuisine.rawValue.lowercased() == option.title.lowercased() })
            }
            return
        }
        
        if option == .all {
            filteredRestaurants = allRestaurants.filter { ($0.title.localizedCaseInsensitiveContains(text) || $0.cuisine.rawValue.localizedStandardContains(text)) }
        } else {
            filteredRestaurants = allRestaurants.filter { ($0.title.localizedCaseInsensitiveContains(text) || $0.cuisine.rawValue.localizedStandardContains(text)) && option.title.lowercased() == $0.cuisine.rawValue.lowercased() }
        }
    }
    
    func loadRestaurants() async {
        do {
            allRestaurants = try await manager.getAll()
            
            let allCuisines = Set(allRestaurants.map { $0.cuisine })
            allScopeOptions = [.all] + allCuisines.map({ SearchScope.cuisine(option: $0) })
            
        } catch {
            print(error)
        }
    }
    
    func getSearchSuggestions() -> [String] {
        guard showSuggestions else { return [] }
        
        var suggestions: [String] = []
        
        let search = searchText.lowercased()
        if search.contains("pa") {
            suggestions.append("Pasta")
        }
        if search.contains("su") {
            suggestions.append("Sushi")
        }
        if search.contains("st") {
            suggestions.append("Steak")
        }
        if search.contains("pu") {
            suggestions.append("Puzata Hata")
        }
        if search.contains("fr") {
            suggestions.append("Frog")
        }
        
        suggestions.append("Sushi")
        
        return suggestions
    }
    
    func getRestSuggestions() -> [Restaurant] {
        guard showSuggestions else { return [] }
        
        var suggestions: [Restaurant] = []
        
        let search = searchText.lowercased()
        if search.contains("ita") {
            suggestions.append(contentsOf: allRestaurants.filter({ $0.cuisine == .italian }))
        }

        
        return suggestions
    }
    
}

struct SearchableModifier: View {
    
    @StateObject private var vm = SearchableModifierViewModel()
    
    var body: some View {
        ScrollView(content: {
            VStack(spacing: 20) {
                ForEach(vm.isSearching ? vm.filteredRestaurants : vm.allRestaurants) { rest in
                    NavigationLink(value: rest) {
                        restaurantRow(rest)
                    }
                }
            }
            .padding(.leading, 16)
        })
        .searchable(text: $vm.searchText, placement: .automatic, prompt: Text("Search reastauraunts..."))
        .searchScopes($vm.selection, scopes: {
            ForEach(vm.allScopeOptions, id: \.self) { scope in
                    Text(scope.title)
                    .tag(scope)
            }
        })
        .searchSuggestions({
            ForEach(vm.getSearchSuggestions(), id: \.self) { sugg in
                Text(sugg)
                    .searchCompletion(sugg)
            }
            ForEach(vm.getRestSuggestions(), id: \.self) { sugg in
                NavigationLink(value: sugg) {
                    Text(sugg.title)
                }
            }
        })
//        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Restaurants")
        .task {
            await vm.loadRestaurants()
        }
        .navigationDestination(for: Restaurant.self) { rest in
            Text(rest.cuisine.rawValue)
        }
    }
    
    private func restaurantRow(_ rest: Restaurant) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(rest.title)
                .font(.headline)
            Text(rest.cuisine.rawValue.capitalized)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .tint(.primary)
    }
}

#Preview {
    NavigationStack {
        SearchableModifier()
    }
}
