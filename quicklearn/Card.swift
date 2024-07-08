import SwiftUI

enum CardType {
    case Arithmetic
}

struct CardData {
    var title : String
    var type : CardType
    var avg_time : Double
}

struct CardView : View {
    let data : CardData
    static var cards = [
        CardData(title: "2-1 Multiplication", type: CardType.Arithmetic, avg_time: 2.54),
        CardData(title: "2-2 Multiplication", type: CardType.Arithmetic, avg_time: 2.54),
        CardData(title: "2-3 Multiplication", type: CardType.Arithmetic, avg_time: 2.54),
        CardData(title: "2-4 Multiplication", type: CardType.Arithmetic, avg_time: 2.54),
        CardData(title: "2-5 Multiplication", type: CardType.Arithmetic, avg_time: 2.54)
    ]
    var body: some View {
        VStack(alignment: .leading) {
            Text(data.title)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(data.avg_time, specifier: "%.2f")", systemImage: "clock")
                Spacer()
                Label("\(data.type)", systemImage: "plus.square")
            }
        }.padding()
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card : CardData = CardData(title: "2-1 Multiplication", type: CardType.Arithmetic, avg_time: 2.54)
        CardView(data: card)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

