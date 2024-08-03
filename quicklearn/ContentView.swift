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
            List(searchResults, id: \.self.title) { card in NavigationLink(destination: CardPage(card: card)) {
                    CardView(data: card)
                }
            }
            .navigationTitle("Cards")
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}


#Preview {
    
    ContentView(cards: cards)
}
