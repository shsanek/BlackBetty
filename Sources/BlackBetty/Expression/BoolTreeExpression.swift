public struct BoolTreeExpression {
    let value: Bool
    
    init(_ value: Bool) {
        self.value = value
    }
}

extension ITreeItem {
    var bool: GenericTreeItem<BoolTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func bool(_ value: Bool) -> BoolTreeExpression {
        return BoolTreeExpression(value)
    }
}

extension BoolTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        return try ObjectContainer(BoolObject(value: self.value))
    }
}
