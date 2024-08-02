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
    
    let background = Color(hex: 0x080c14)
    let text = Color(hex: 0xE0F0FF)
    let primary = Color(hex: 0x3377FF)
    let secondary = Color(hex: 0x0c1a36)
    let accent = Color(hex: 0x3377FF)
    
    @State private var x: Int = 0
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(card.template.eq) = \(x)")
                    Spacer()
                }
                .padding(50)
                .navigationBarTitle(Text(card.title))
                Spacer()
                Grid {
                    ForEach(0..<3) { n1 in
                        GridRow {
                            ForEach(1..<4) { n2 in
                                Button(action: {() -> () in x = 10*abs(x) + 3*n1 + n2}) {Text("\(3*n1 + n2)")}
                                    .backgroundStyle(NumPadButtonStyle())
                            }
                        }
                    }
                    GridRow {
                        Button(action: {() -> () in x = -x}) {Text("-")}
                            .buttonStyle(NumPadButtonStyle())
                        Button(action: {() -> () in x = 10*x + 0}) {Text("0")}
                            .buttonStyle(NumPadButtonStyle())
                        Button(action: {() -> () in x = Int(x/10)}) {Label("test", systemImage: "delete.left").labelStyle(.iconOnly)}
                            .buttonStyle(NumPadButtonStyle())
                    }
                }
                .padding(10)
                .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)).fill(secondary))
            }.background(background)
        }
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
