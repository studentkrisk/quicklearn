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
    let gen : () -> ([Int])
    let eq : String
    let ans : ([Int], [Int]) -> (Bool)
    var num_ans: Int = 1
}

struct CardData {
    var title : String
    var type : CardType
    var avg_time : Double?
    var template : CardTemplate
}

func generatePrimes(to n: Int) -> [Int] {

    if n <= 5 {
        return [2, 3, 5].filter { $0 <= n }
    }

    var arr = Array(stride(from: 3, through: n, by: 2))

    let squareRootN = Int(Double(n).squareRoot())
    for index in 0... {
        if arr[index] > squareRootN { break }
        let num = arr.remove(at: index)
        arr = arr.filter { $0 % num != 0 }
        arr.insert(num, at: index)
    }

    arr.insert(2, at: 0)
    return arr
}

var cards = [
    CardData(
        title: "1-1 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 1...9), Int.random(in: 1...9)]}
            , eq: "%d + %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] + vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "2-1 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 10...99), Int.random(in: 1...9)].shuffled()},
            eq: "%d + %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] + vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "2-2 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 10...99), Int.random(in: 10...99)]},
            eq: "%d + %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] + vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "3-3 Addition",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 100...999), Int.random(in: 100...999)]},
            eq: "%d + %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] + vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "1-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 1...9), Int.random(in: 1...9)]},
            eq: "%d ⋅ %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] * vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "2-1 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 10...99), Int.random(in: 1...9)].shuffled()},
            eq: "%d ⋅ %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] * vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "2-2 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 10...99), Int.random(in: 10...99)]},
            eq: "%d ⋅ %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] * vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "3-3 Multiplication",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {return [Int.random(in: 100...999), Int.random(in: 100...999)]},
            eq: "%d ⋅ %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return vars[0] * vars[1] == ans[0]}
        )
    ),
    CardData(
        title: "Linear Equations",
        type: CardType.Algebra,
        template: CardTemplate(
            gen: {
                let a = Int.random(in: 1...9)
                let b = Int.random(in: 1...9)
                return [a, b, Int.random(in: 1...9)*a + b]
            }, eq: "%dx + %d = %d",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return (vars[2] - vars[1])/vars[0] == ans[0]}
        )
    ),
    CardData(
        title: "Factoring Semiprimes",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {[generatePrimes(to: 20).randomElement()! * generatePrimes(to: 20).randomElement()!]},
            eq: "%d = ? ⋅ ?",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return (vars[0] == ans[0]*ans[1] && ans[0] != 1) && ans[1] != 1},
            num_ans: 2
        )
    ),
    CardData(
        title: "Solving Quadratics (a=1)",
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {
                let x1 = Int.random(in: -10...10)
                let x2 = Int.random(in: -10...10)
                return [x1 + x2, x1 * x2]
            },
            eq: "x² + %dx + %d = 0",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return (vars[0] == ans[0] + ans[1] && vars[1] == ans[0]*ans[1])},
            num_ans: 2
        )
    ),
    CardData(
        title: "Factoring Triadics", // idk
        type: CardType.Arithmetic,
        template: CardTemplate(
            gen: {[]},
            eq: "ax^2 + bx + c",
            ans: {(ans: [Int], vars : [Int]) -> Bool in return (vars[2] - vars[1])/vars[0] == ans[0]},
            num_ans: 2
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
    
    @State private var ans: [Int]
    @State private var state: [Int] = []
    @State private var eq: String
    @State private var cur: Int = 0
    
    init(card: CardData) {
        self.card = card
        self.ans = Array(1...card.template.num_ans).map({0*$0})
        self.eq = card.template.eq
    }
    
    func pressNumPadButton(button: String) {
        switch button {
        case "next":
            cur += 1
            cur %= ans.count
        case "last":
            cur -= 1
            cur %= ans.count
        case "-":
            ans[cur] *= -1
        case "delete":
            ans[cur] = Int(ans[cur]/10)
        default:
            ans[cur] = 10*ans[cur] + Int(button)!
        }
        if abs(ans[cur]) >= 1000000 {
            ans[cur] = Int(ans[cur]/10)
        }
        if card.template.ans(ans, state) {
            reset()
        }
    }
    
    func reset() {
        state = []
        cur = 0
        ans = Array(1...card.template.num_ans).map({0*$0})
        state = card.template.gen()
        eq = String(format: card.template.eq, arguments: state)
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
                        HStack {
                            ForEach(0..<ans.count) {
                                Text("\(ans[$0])")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Colors.text)
                                    .fontWeight(cur == $0 ? .bold : .regular)
                            }
                        }
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
                        Button(action: {pressNumPadButton(button: "fraction")}) {Label("", systemImage: "divide").labelStyle(.iconOnly)}
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
