public struct ArgumentNameTreeExpression {
    let identifier: String
    let expression: ITreeItem

    init(identifier: String, expression: ITreeItem) {
        self.expression = expression
        self.identifier = identifier
    }
}

extension ITreeItem {
    var argumentName: GenericTreeItem<ArgumentNameTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func argumentName(identifier: String, expression: ITreeItem) -> ArgumentNameTreeExpression {
        return ArgumentNameTreeExpression(identifier: identifier, expression: expression)
    }
}

extension ArgumentNameTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        return nil
    }
}
