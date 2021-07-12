public final class IfElseTreeExpression {
    let ifExpression: GenericTreeItem<IfTreeExpression>
    let elseAction: ITreeItem

    init(ifExpression: GenericTreeItem<IfTreeExpression>, elseAction: ITreeItem) {
        self.ifExpression = ifExpression
        self.elseAction = elseAction
    }
}

extension ITreeItem {
    var `ifelse`: GenericTreeItem<IfElseTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func `ifelse`(ifExpression: GenericTreeItem<IfTreeExpression>, elseAction: ITreeItem) -> IfElseTreeExpression {
        return IfElseTreeExpression(ifExpression: ifExpression, elseAction: elseAction)
    }
}

extension IfElseTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        let enable = try ifExpression.expr.condition.run(currentContext)
        if (enable?.object as? BoolObject)?.value ?? false {
            _ = try ifExpression.expr.block.run(currentContext)
        } else {
            _ = try elseAction.run(currentContext)
        }
        return ObjectContainer(object: EmptyObject())
    }
}
