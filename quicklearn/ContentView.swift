import SwiftUI
 
struct ContentView: View {
    let cards : [CardData]
    var body: some View {
        NavigationStack {
            List(cards, id: \.self.title) { card in NavigationLink(destination: CardPage(card: card)) {
                    CardView(data: card)
                }
            }
            .navigationTitle("Cards")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}


#Preview {
    
    ContentView(cards: cards)
}
