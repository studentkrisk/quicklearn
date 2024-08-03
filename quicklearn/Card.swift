import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

enum CardType {
    case Arithmetic
}

struct CardTemplate {
    var vars : [String]
    var gen : [ClosedRange<Int>]
    var eq : String
    var ans : (Int, [Int]) -> (Bool)
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
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "2-1 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...9], eq: "x + y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "2-2 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...99], eq: "x + y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "1-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...9, 1...9], eq: "x ⋅ y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "2-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...9], eq: "x ⋅ y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "2-2 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [1...99, 1...99], eq: "x ⋅ y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] * vars[1] == ans}
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
    var card : CardData
    
    let background = Color(hex: 0x080c14)
    let text = Color(hex: 0xE0F0FF)
    let primary = Color(hex: 0x3377FF)
    let secondary = Color(hex: 0x0c1a36)
    let accent = Color(hex: 0x3377FF)
    
    @State private var ans: Int = 0
    @State private var state: [Int] = []
    @State private var eq: String
    
    init(card: CardData) {
        self.card = card
        self.eq = card.template.eq
    }
    
    func pressNumPadButton(button: String) {
        switch button {
        case "-":
            ans *= -1
        case "delete":
            ans = Int(ans/10)
        default:
            ans = 10*ans + Int(button)!
        }
        if abs(ans) >= 1000000 {
            ans = Int(ans/10)
        }
        if card.template.ans(ans, state) {
            reset()
        }
    }
    
    func reset() {
        eq = card.template.eq
        state = []
        ans = 0
        for i in 0..<card.template.gen.count {
            state.append(Int.random(in: card.template.gen[i]))
            eq = eq.replacingOccurrences(of: card.template.vars[i], with: String(state.last!))
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(eq) = \(ans)")
                        .font(.system(size: 32))
                    Spacer()
                }
                .padding(50)
                .navigationBarTitle(Text(card.title))
                Spacer()
                Grid {
                    ForEach(0..<3) { n1 in
                        GridRow {
                            ForEach(1..<4) { n2 in
                                Button("\(3*n1 + n2)") {
                                    pressNumPadButton(button: "\(3*n1 + n2)")
                                }
                                .buttonStyle(NumPadButtonStyle())
                            }
                        }
                    }
                    GridRow {
                        Button(action: {pressNumPadButton(button: "-")}) {Text("-")}
                            .buttonStyle(NumPadButtonStyle())
                        Button(action: {pressNumPadButton(button: "0")}) {Text("0")}
                            .buttonStyle(NumPadButtonStyle())
                        Button(action: {pressNumPadButton(button: "delete")}) {Label("", systemImage: "delete.left").labelStyle(.iconOnly)}
                            .buttonStyle(NumPadButtonStyle())
                    }
                }
                .padding(10)
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)).fill(secondary))
            }.background(background)
        }.onAppear(perform: reset)
    }
}

struct NumPadButtonStyle: ButtonStyle {
    let background = Color(hex: 0x080c14)
    let text = Color(hex: 0xE0F0FF)
    let primary = Color(hex: 0x3377FF)
    let secondary = Color(hex: 0x0c1a36)
    let accent = Color(hex: 0x3377FF)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
            .background(Capsule().fill(primary))
            .foregroundColor(text)
            .font(.system(size: 24))
            .phaseAnimator([1, 1.25, 1]) { view, phase in
                view
                    .scaleEffect(phase)
            } animation: { phase in
                    .snappy(duration: 0.2)
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
        CardPage(card: cards[0])
    }
}
