public struct BinaryOperatorTreeExpression {
    let left: ITreeItem
    let right: ITreeItem
    let `operator`: String

    init(left: ITreeItem, right: ITreeItem, `operator`: String) {
        self.left = left
        self.right = right
        self.`operator` = `operator`
    }
}

extension ITreeItem {
    var binaryOperator: GenericTreeItem<BinaryOperatorTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func binaryOperator(left: ITreeItem, right: ITreeItem, `operator`: String) -> ITreeExpression {
        return BinaryOperatorTreeExpression(left: left, right: right, operator: `operator`)
    }
}

extension BinaryOperatorTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        guard let target = try left.run(currentContext),
              let right = try right.run(currentContext),
              let function = target.object?.context.fetch(name: `operator`).object as? IFunction
        else {
            return nil
        }
        return try function.run([right])
    }
}
