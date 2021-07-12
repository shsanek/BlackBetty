final class TokenResult {
    private(set) var currentText: String = ""
    private(set) var tokens: [Token] = []
    private(set) var position: Position = Position()
    private var currentPosition: Position = Position()
}

extension TokenResult {
    func addSymbol(_ symbol: Character) {
        self.currentText.append(String(symbol))
        if symbol == "\n" {
            self.currentPosition.column = 0
            self.currentPosition.row += 1
        } else {
            self.currentPosition.column += 1
        }
    }
    
    func updatePosition() {
        self.position = self.currentPosition
    }
    
    func clear() {
        self.updatePosition()
        self.currentText = ""
    }

    func addToken(_ token: Token.TokenType) {
        self.tokens.append(Token(type: token, position: position, text: self.currentText))
    }
}
