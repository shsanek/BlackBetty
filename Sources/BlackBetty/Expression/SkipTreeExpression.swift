public struct SkipTreeExpression {
    init() { }
}

extension ITreeItem {
    var skip: GenericTreeItem<SkipTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static var skip: ITreeExpression {
        return SkipTreeExpression()
    }
}

extension SkipTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        return nil
    }
}
