final class NumberTokenNode: ITokenNode {
    static let allSymbol = "1234567890"
    var part = Part.first
    enum Part {
        case first
        case second
    }

    func next(symbol: Character, result: TokenResult) -> ITokenNode? {
        if NumberTokenNode.allSymbol.contains(symbol) {
            return self
        }
        if symbol == "." && part == .first {
            part = .second
            return self
        }
        let value = Double(result.currentText)
        result.addToken(.number(value ?? 0))
        return nil
    }
}
