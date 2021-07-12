public struct IfTreeExpression {
    let condition: ITreeItem
    let block: GenericTreeItem<BlockTreeExpression>

    init(condition: ITreeItem, block: GenericTreeItem<BlockTreeExpression>) {
        self.condition = condition
        self.block = block
    }
}

extension ITreeItem {
    var `if`: GenericTreeItem<IfTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func `if`(condition: ITreeItem, block: GenericTreeItem<BlockTreeExpression>) -> ITreeExpression {
        return IfTreeExpression(condition: condition, block: block)
    }
}

extension IfTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        let enable = try condition.run(currentContext)
        if (enable?.object as? BoolObject)?.value ?? false {
            _ = try block.run(currentContext)
        }
        return ObjectContainer(object: EmptyObject())
    }
}
