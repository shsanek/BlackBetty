public struct BlockTreeExpression {
    let expressions: [ITreeItem]

    init(_ expressions: [ITreeItem]) {
        self.expressions = expressions
    }
}

extension ITreeItem {
    var block: GenericTreeItem<BlockTreeExpression>? {
        self.convert()
    }
}

extension EF{
    static func block(_ expressions: [ITreeItem]) -> ITreeExpression {
        return BlockTreeExpression(expressions)
    }
}

extension BlockTreeExpression: ITreeExpression {
    public func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        let context = BBContext(global: currentContext.global, superContext: currentContext)
        for item in expressions {
            do {
                _ = try item.run(context)
            } catch SystemClose.return(let container) {
                throw SystemClose.return(container)
            } catch {
                throw error
            }
        }
        return nil
    }
}
