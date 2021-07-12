public struct NumberTreeExpression{
    let value: Double
    
    init(_ value: Double) {
        self.value = value
    }
}

extension ITreeItem {
    var number: GenericTreeItem<NumberTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func number(_ value: Double) -> ITreeExpression {
        return NumberTreeExpression(value)
    }
}

extension NumberTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        return try ObjectContainer(NumberObject(value: self.value))
    }
}
