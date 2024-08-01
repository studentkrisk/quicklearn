import SwiftUI

enum CardType {
    case Arithmetic
}

struct CardTemplate {
    var vars : [String]
    var gen : [ClosedRange<Int>]
    var eq : String
    var ans : (Int, Int...) -> (Bool)
}

struct CardData {
    var title : String
    var type : CardType
    var avg_time : Double?
    var template : CardTemplate
}

var cards = [
    CardData(
        title: "1-1 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...9, 1...9], eq: "x + y",
            ans: {(ans, vars : Int...) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "2-1 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...9], eq: "x + y",
            ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "2-2 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...99], eq: "x + y",
            ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "1-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...9, 1...9], eq: "x * y",
            ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "2-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...9], eq: "x * y",
            ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "2-2 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...99], eq: "x * y",
            ans: {(ans: Int, vars : Int...) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
]

struct CardView : View {
    let data : CardData
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

struct CardPage : View {
    let card : CardData
    @State private var x: Int = 0
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Text("\(card.template.eq) = ")
                    TextField("Answer", value: $x, format: .number)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(50)
                .navigationBarTitle(Text(card.title))
                Spacer()
                Grid {
                    ForEach(0..<3) { n1 in
                        GridRow {
                            ForEach(1..<4) { n2 in
                                Button(action: {() -> () in x = 10*abs(x) + 3*n1 + n2}) {Text("\(3*n1 + n2)")}
                                .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                            }
                        }
                    }
                    GridRow {
                        Button(action: {() -> () in x = -x}) {Text("-")}.padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                        Button(action: {() -> () in x = 10*x + 0}) {Text("0")}
                            .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                        Button(action: {() -> () in x = Int(x/10)}) {Label("", systemImage: "delete.left")}
                            .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                    }
                }
            }
        }
    }
}


//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let card : CardData = cards[0]
//        CardView(data: card)
//            .previewLayout(.fixed(width: 400, height: 60))
//    }
//}

struct CardPage_Previews: PreviewProvider {
    static var previews: some View {
        let card : CardData = cards[0]
        CardPage(card: card)
    }
}
