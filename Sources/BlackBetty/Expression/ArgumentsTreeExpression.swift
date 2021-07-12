public struct ArgumentsTreeExpression {
    let arguments: [GenericTreeItem<ArgumentNameTreeExpression>]

    init(arguments: [GenericTreeItem<ArgumentNameTreeExpression>]) {
        self.arguments = arguments
    }
}

extension ITreeItem {
    var arguments: GenericTreeItem<ArgumentsTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func arguments(arguments: [GenericTreeItem<ArgumentNameTreeExpression>]) -> ArgumentsTreeExpression {
        return ArgumentsTreeExpression(arguments: arguments)
    }
}

extension ArgumentsTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        if arguments.count == 1 {
            return try arguments[0].expr.expression.run(currentContext)
        }
        return nil
    }
}
