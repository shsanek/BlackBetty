public struct AssignOperatorTreeExpression {
    let varIdentifier: ITreeItem
    let right: ITreeItem

    init(varIdentifier: ITreeItem, right: ITreeItem) {
        self.varIdentifier = varIdentifier
        self.right = right
    }
}

extension ITreeItem {
    var assignOperator: GenericTreeItem<AssignOperatorTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func assignOperator(varIdentifier: ITreeItem, right: ITreeItem) -> ITreeExpression {
        return AssignOperatorTreeExpression(varIdentifier: varIdentifier, right: right)
    }
}

extension AssignOperatorTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        guard let target = try varIdentifier.run(currentContext),
              let right = try right.run(currentContext)
        else {
            return nil
        }
        target.object = right.object
        return nil
    }
}
