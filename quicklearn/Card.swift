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
    case Algebra
}

struct Colors {
    static let background = Color(hex: 0x080c14)
    static let text = Color(hex: 0xE0F0FF)
    static let primary = Color(hex: 0x3377FF)
    static let secondary = Color(hex: 0x0c1a36)
    static let accent = Color(hex: 0x3377FF)
}

struct CardTemplate {
    var vars : [String]
    var gen : [([Int]) -> [Int]]
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
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(1...9)},
                {(state: [Int]) -> [Int] in return Array(1...9)}],
            eq: "x + y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "2-1 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(10...99)},
                {(state: [Int]) -> [Int] in return Array(1...9)}],
            eq: "x + y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "2-2 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(10...99)},
                {(state: [Int]) -> [Int] in return Array(10...99)}],
            eq: "x + y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "3-3 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(100...999)},
                {(state: [Int]) -> [Int] in return Array(100...999)}],
            eq: "x + y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] + vars[1] == ans}
        )
    ),
    CardData(
        title: "1-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(1...9)},
                {(state: [Int]) -> [Int] in return Array(1...9)}],
            eq: "x ⋅ y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "2-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(10...99)},
                {(state: [Int]) -> [Int] in return Array(1...9)}],
            eq: "x ⋅ y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "2-2 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(10...99)},
                {(state: [Int]) -> [Int] in return Array(10...99)}],
            eq: "x ⋅ y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "3-3 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["x", "y"], gen: [
                {(state: [Int]) -> [Int] in return Array(100...999)},
                {(state: [Int]) -> [Int] in return Array(100...999)}],
            eq: "x ⋅ y",
            ans: {(ans: Int, vars : [Int]) -> Bool in return vars[0] * vars[1] == ans}
        )
    ),
    CardData(
        title: "Linear Equations",
        type: CardType.Algebra,
        template: CardTemplate(
            vars: ["a", "b", "c"], gen: [
                {(state: [Int]) -> [Int] in return Array(1...9)},
                {(state: [Int]) -> [Int] in return Array(1...9)},
                {(state: [Int]) -> [Int] in return Array(1...9).map({state[0]*$0+state[1]})}],
            eq: "ax + b = c",
            ans: {(ans: Int, vars : [Int]) -> Bool in return (vars[2] - vars[1])/vars[0] == ans}
        )
    ),
    CardData(
        title: "Factoring Semiprimes",
        type: CardType.Arithmetic,
        template: CardTemplate(
            vars: ["a"], gen: [
                {(state: [Int]) -> [Int] in return Array(1...9)},
                {(state: [Int]) -> [Int] in return Array(1...9)},
                {(state: [Int]) -> [Int] in return Array(1...9).map({state[0]*$0+state[1]})}],
            eq: "ax + b = c",
            ans: {(ans: Int, vars : [Int]) -> Bool in return (vars[2] - vars[1])/vars[0] == ans}
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
            state.append(card.template.gen[i](state).randomElement()!)
            eq = eq.replacingOccurrences(of: card.template.vars[i], with: String(state.last!))
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Text("\(eq)")
                            .font(.system(size: 32))
                        Text("\(ans)")
                            .font(.system(size: 24))
                    }
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
                                }.buttonStyle(NumPadButtonStyle())
                            }
                            switch n1 {
                            case 0:
                                Button(action: {pressNumPadButton(button: "delete")}) {Label("", systemImage: "delete.left").labelStyle(.iconOnly)}
                                    .buttonStyle(NumPadButtonStyle())
                            case 1:
                                Button("-") {pressNumPadButton(button: "-")}
                                    .buttonStyle(NumPadButtonStyle())
                            case 2:
                                Button(".") {pressNumPadButton(button: ".")}
                                    .buttonStyle(NumPadButtonStyle())
                            default:
                                Button("-") {pressNumPadButton(button: "-")}
                                    .buttonStyle(NumPadButtonStyle())
                            }
                        }
                    }
                    GridRow {
                        Button(action: {pressNumPadButton(button: "last")}) {Label("", systemImage: "arrowtriangle.left").labelStyle(.iconOnly)}
                            .buttonStyle(NumPadButtonStyle())
                        Button("0") {pressNumPadButton(button: "0")}
                            .buttonStyle(NumPadButtonStyle())
                        Button(action: {pressNumPadButton(button: "next")}) {Label("", systemImage: "arrowtriangle.right").labelStyle(.iconOnly)}
                            .buttonStyle(NumPadButtonStyle())
                        Button(action: {pressNumPadButton(button: "next")}) {Label("", systemImage: "arrowtriangle.right").labelStyle(.iconOnly)}
                            .buttonStyle(NumPadButtonStyle())
                    }
                }
                .padding(10)
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)).fill(Colors.secondary))
            }.background(Colors.background)
        }.onAppear(perform: reset)
    }
}

struct NumPadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 75, height: 60, alignment: Alignment.center)
            .background(Capsule().fill(Colors.primary))
            .foregroundColor(Colors.text)
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
//
//struct CardPage_Previews: PreviewProvider {
//    static var previews: some View {
//        CardPage(card: cards[0])
//    }
//}

#Preview {
    ContentView(cards: cards)
}
