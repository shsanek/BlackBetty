final class StringTokenNode: ITokenNode {
    enum State {
        case normal
        case end
    }
    var state = State.normal
    var lastSymbol: String? = nil

    func next(symbol: Character, result: TokenResult) -> ITokenNode? {
        if state == .end {
            var text = result.currentText
            text.removeFirst()
            text.removeLast()
            result.addToken(.string(text))
            return nil
        }
        if symbol == "\0" {
            return nil
        }
        if symbol == "\"" && lastSymbol != "\\" {
            state = .end
        }
        return self
    }
}
