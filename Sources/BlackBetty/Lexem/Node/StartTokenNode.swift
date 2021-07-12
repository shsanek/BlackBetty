final class StartTokenNode: ITokenNode {
    let shornNodes = [
        NextTokenNode(symbol: "{", token: .openCodeBlock),
        NextTokenNode(symbol: "}", token: .closeCodeBlock),
        NextTokenNode(symbol: "(", token: .openFunctionArguments),
        NextTokenNode(symbol: ")", token: .closeFunctionArguments),
        NextTokenNode(symbol: ",", token: .separatorFunctionArguments),
        NextTokenNode(symbol: ":", token: .nameSeparatorFunctionArgument),
        NextTokenNode(symbol: ";", token: .superEnd),
        NextTokenNode(symbol: "\n", token: .end),
        NextTokenNode(symbol: "=", token: .assignOperator, next: NextTokenNode(symbol: "=", token: .binOperator("==", priority: 95))),
        NextTokenNode(symbol: "+", token: .binOperator("+", priority: 100)),
        NextTokenNode(symbol: "-", token: .binOperator("-", priority: 100)),
        NextTokenNode(symbol: "*", token: .binOperator("*", priority: 101)),
        NextTokenNode(symbol: "/", token: .binOperator("/", priority: 101)),
        NextTokenNode(symbol: "&", token: .binOperator("&", priority: 110), next: NextTokenNode(symbol: "&", token: .binOperator("&&", priority: 94))),
        NextTokenNode(symbol: "|", token: .binOperator("|", priority: 110), next: NextTokenNode(symbol: "|", token: .binOperator("||", priority: 94))),
        NextTokenNode(symbol: "!", token: .identifier("!"), next: NextTokenNode(symbol: "=", token: .binOperator("!=", priority: 95))),
        NextTokenNode(symbol: ".", token: .pointOperator, next: NextTokenNode(symbol: ".", token: .range)),
    ]
    func next(symbol: Character, result: TokenResult) -> ITokenNode? {
        if IdentifaerTokenNode.startSymbols.contains(symbol) {
            return IdentifaerTokenNode()
        }
        if NumberTokenNode.allSymbol.contains(symbol) {
            return NumberTokenNode()
        }
        if symbol == "\"" { return StringTokenNode() }
        
        for node in shornNodes {
            if node.symbol == symbol {
                return node
            }
        }

        if symbol == " " || symbol == "\t" { return SpaceTokenNode() }

        return nil
    }
}
