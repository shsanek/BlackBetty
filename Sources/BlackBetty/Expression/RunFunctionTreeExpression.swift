public struct RunFunctionTreeExpression {
    let expression: ITreeItem
    let arguments: GenericTreeItem<ArgumentsTreeExpression>

    init(expression: ITreeItem, arguments: GenericTreeItem<ArgumentsTreeExpression>) {
        self.expression = expression
        self.arguments = arguments
    }
}

extension ITreeItem {
    var runFunction: GenericTreeItem<RunFunctionTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func runFunction(expression: ITreeItem, arguments: GenericTreeItem<ArgumentsTreeExpression>) -> ITreeExpression {
        return RunFunctionTreeExpression(expression: expression, arguments: arguments)
    }
}

extension RunFunctionTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        let objects = try arguments.expr.arguments.map { try $0.expr.expression.run(currentContext) ?? ObjectContainer() }
        guard let function = try expression.run(currentContext)?.object as? IFunction else {
            throw SyntaxisError.error
        }
        do {
            return try function.run(objects)
        }
        catch SystemClose.return(let container) {
            return container
        }
        catch {
            throw error
        }
    }
}
