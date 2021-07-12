public protocol ITreeItem {
    var expression: ITreeExpression { get }
    var position: Position? { get }
    var text: String? { get }
}

public struct TreeItem: ITreeItem {
    public let expression: ITreeExpression
    public let position: Position?
    public let text: String?
}

public struct GenericTreeItem<ExpressionType: ITreeExpression>: ITreeItem {
    public var expression: ITreeExpression {
        return expr
    }
    public let expr: ExpressionType
    public let position: Position?
    public let text: String?
    
    init(expression: ExpressionType, position: Position?, text: String?) {
        self.expr = expression
        self.position = position
        self.text = text
    }
}


extension ITreeItem {
    func convert<ExpressionType: ITreeExpression>() -> GenericTreeItem<ExpressionType>? {
        guard let expression = self.expression as? ExpressionType else {
            return nil
        }
        return GenericTreeItem<ExpressionType>(expression: expression, position: self.position, text: self.text)
    }
    
    func run(_ currentContext: BBContext) throws -> ObjectContainer? {
        return try self.expression.run(currentContext)
    }
}

public protocol ITreeExpression {
    func run(_ currentContext: BBContext) throws -> ObjectContainer?
}

public struct EF{ }
