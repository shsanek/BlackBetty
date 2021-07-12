public struct IdentifierTreeExpression {
    let identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
}

extension ITreeItem {
    var identifier: GenericTreeItem<IdentifierTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func identifier(_ identifier: String) -> ITreeExpression {
        return IdentifierTreeExpression(identifier)
    }
}

extension IdentifierTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        return currentContext.fetch(name: identifier)
    }
}
