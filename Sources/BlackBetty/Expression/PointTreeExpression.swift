public struct PointTreeExpression {
    let expression: ITreeItem
    let identifier: String

    init(expression: ITreeItem, identifier: String) {
        self.expression = expression
        self.identifier = identifier
    }
}

extension ITreeItem {
    var point: GenericTreeItem<PointTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func point(expression: ITreeItem, identifier: String) -> ITreeExpression {
        return PointTreeExpression(expression: expression, identifier: identifier)
    }
}

extension PointTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        let target = try expression.run(currentContext)?.object
        return target?.context.fetch(name: identifier).retaint(target)
    }
}
