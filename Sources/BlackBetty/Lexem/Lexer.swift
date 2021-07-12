public final class Lexer {
    public static func fetchTokens(_ text: String) -> (tokens: [Token], error: Error?) {
        let startNode: ITokenNode = StartTokenNode()
        let symbols = text.map { $0 }
        var node = startNode
        var j = 0
        var errorsContainer = BBErrorsContainer()
        let result = TokenResult()
        while j < symbols.count {
            let symbol = symbols[j]
            let nextNode = node.next(symbol: symbol, result: result)
            if nextNode == nil {
                result.clear()
                if node === startNode {
                    errorsContainer.addError(BBError.customError(position: result.position, text: String(symbol), "unknown symbols"))
                    j += 1
                }
            } else {
                result.addSymbol(symbol)
                j += 1
            }
            node = nextNode ?? startNode
        }
        _ = node.next(symbol: "\0", result: result)
        return (tokens: result.tokens, error: errorsContainer.resultError)
    }
}
