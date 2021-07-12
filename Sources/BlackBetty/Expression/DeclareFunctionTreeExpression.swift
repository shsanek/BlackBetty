public struct DeclareFunctionTreeExpression {
    let identifier: GenericTreeItem<IdentifierTreeExpression>?
    let arguments: GenericTreeItem<ArgumentsTreeExpression>
    let block: GenericTreeItem<BlockTreeExpression>

    init(identifier: GenericTreeItem<IdentifierTreeExpression>?, arguments: GenericTreeItem<ArgumentsTreeExpression>, block: GenericTreeItem<BlockTreeExpression>) {
        self.identifier = identifier
        self.arguments = arguments
        self.block = block
    }
}

extension ITreeItem {
    var declareFunction: GenericTreeItem<DeclareFunctionTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func declareFunction(
        identifier: GenericTreeItem<IdentifierTreeExpression>?,
        arguments: GenericTreeItem<ArgumentsTreeExpression>,
        block: GenericTreeItem<BlockTreeExpression>
    ) -> ITreeExpression {
        return DeclareFunctionTreeExpression(identifier: identifier, arguments: arguments, block: block)
    }
}


extension DeclareFunctionTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        let arguments = self.arguments.expr.arguments.map { ($0.expr.identifier, $0.expr.expression) }
        let obj = CustomFunction(arguments: arguments, block: block.expr.expressions, context: currentContext)
        if let identifier = identifier {
            currentContext.fetch(name: identifier.expr.identifier).object = obj
        } else {
            return ObjectContainer(object: obj)
        }
        return nil
    }
}
