final class OneTokenNode: ITokenNode {
    private let token: Token.TokenType

    init(token: Token.TokenType) {
        self.token = token
    }

    func next(symbol: Character, result: TokenResult) -> ITokenNode? {
        result.addToken(token)
        return nil
    }
}
