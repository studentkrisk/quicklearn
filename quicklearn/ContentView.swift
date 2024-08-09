import SwiftUI
 
struct ContentView: View {
    @State private var searchText = ""
    
    let cards: [CardData]
    var searchResults : [CardData] {
        if searchText.isEmpty {
            return cards
        } else {
            return cards.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("My Cards")) {}
                Section(header: Text("Default Cards")) {
                    ForEach(searchResults, id: \.title) {card in
                        NavigationLink(destination: CardPage(card: card)) {
                            CardView(data: card)
                        }
                    }
                }
            }
            .navigationTitle("Cards")
        }
        .background(Colors.background)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}


#Preview {
    ContentView(cards: cards)
}
