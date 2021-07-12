public struct ReturnTreeExpression {
    let expression: ITreeItem

    init(_ expression: ITreeItem) {
        self.expression = expression
    }
}

extension ITreeItem {
    var `return`: GenericTreeItem<ReturnTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func `return`(_ expression: ITreeItem) -> ITreeExpression {
        return ReturnTreeExpression(expression)
    }
}

extension ReturnTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        let container = try expression.run(currentContext)
        throw SystemClose.return(container)
    }
}
