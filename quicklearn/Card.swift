import SwiftUI

enum CardType {
    case Arithmetic
}

enum AnswerType {
    case int(Int)
    case ints([Int])
    case float(Float)
    case floats([Float])
    case double(Double)
    case doubles([Double])
}

struct CardTemplate {
    var vars : [String]
    var eq : String
    var ans : (Int, Int...) -> (Bool)
}

struct CardData {
    var title : String
    var type : CardType
    var avg_time : Double?
    var template : CardTemplate
}

struct CardView : View {
    let data : CardData
    static var cards = [
        CardData(
            title: "1-1 Addition",
            type: CardType.Arithmetic,
            template: CardTemplate(vars: ["x", "y"], eq: "x + y",
                ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] + vars[1] == ans}
            )
        ),
        CardData(
            title: "2-1 Addition",
            type: CardType.Arithmetic,
            template: CardTemplate(vars: ["x", "y"], eq: "x + y",
                ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] + vars[1] == ans}
            )
        ),
        CardData(
            title: "2-2 Addition",
            type: CardType.Arithmetic,
            template: CardTemplate(vars: ["x", "y"], eq: "x + y",
                ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] + vars[1] == ans}
            )
        ),
        CardData(
            title: "1-1 Multiplication",
            type: CardType.Arithmetic,
            template: CardTemplate(vars: ["x", "y"], eq: "x * y",
                ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] * vars[1] == ans}
            )
        ),
        CardData(
            title: "2-1 Multiplication",
            type: CardType.Arithmetic,
            template: CardTemplate(vars: ["x", "y"], eq: "x * y",
                ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] * vars[1] == ans}
            )
        ),
        CardData(
            title: "2-2 Multiplication",
            type: CardType.Arithmetic,
            template: CardTemplate(vars: ["x", "y"], eq: "x * y",
               ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] * vars[1] == ans}
            )
        ),
    ]
    var body: some View {
        VStack(alignment: .leading) {
            Text(data.title)
                .font(.headline)
            Spacer()
            HStack {
                if let time = data.avg_time {
                    Label("\(time, specifier: "%.2f")", systemImage: "clock")
                } else {
                    Label("—", systemImage: "clock")
                }
                Spacer()
                Label("\(data.type)", systemImage: "plus.square")
            }
        }.padding()
    }
}

struct CardPage {
    let template : CardTemplate
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card : CardData = CardView.cards[0]
        CardView(data: card)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

