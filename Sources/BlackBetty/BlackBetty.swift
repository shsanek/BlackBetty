public final class BlackBetty {
    @discardableResult
    public static func run(_ code: String, context: BBContext = BBContext()) throws -> IObject? {
        let tokenResult = Lexer.fetchTokens(code)
        let tree = try TreeBuilder.buildTree(with: tokenResult.tokens)
        return try Runner(context: context).run(tree.items)?.object
    }
}
