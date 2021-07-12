public struct StringTreeExpression{
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
}

extension ITreeItem {
    var string: GenericTreeItem<StringTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func string(_ value: String) -> ITreeExpression {
        return StringTreeExpression(value)
    }
}

extension StringTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        return try ObjectContainer(StringObject(value: self.value))
    }
}
