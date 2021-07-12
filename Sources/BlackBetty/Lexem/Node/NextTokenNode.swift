final class NextTokenNode: ITokenNode  {
    let symbol: Character
    let token: Token.TokenType
    let next: NextTokenNode?
    
    init(symbol: Character, token: Token.TokenType, next: NextTokenNode? = nil) {
        self.symbol = symbol
        self.token = token
        self.next = next
    }
    
    func next(symbol: Character, result: TokenResult) -> ITokenNode? {
        if next?.symbol == symbol {
            return next
        }
        result.addToken(token)
        return nil
    }
}
