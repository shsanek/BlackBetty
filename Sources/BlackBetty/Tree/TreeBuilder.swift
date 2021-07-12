public class TreeBuilder {
    private var tokens: [Token]
    private var indexToken: Int = 0
    private var stack: [StackItem] = [StackItem()]
    private var activityToken: Token?

    private init(tokens: [Token]) {
        self.tokens = tokens
    }
}

extension TreeBuilder {
    static func buildTree(with tokens: [Token]) throws -> TreeNode {
        return try TreeBuilder(tokens: tokens).getTree()
    }
}

private extension TreeBuilder {
    func getTree() throws -> TreeNode {
        while tokens.count > indexToken {
            do {
                try self.expression()
            }
            catch {
            }
        }
        while self.stack.count > 1 {
            do {
                try self.closeStack()
            }
            catch {
            }
        }
        do  {
            try self.closeOperator(with: 0)
        }
        catch {
        }
        return try TreeNode(items: self.getStackItem().items)
    }
}

private extension TreeBuilder {
    func nextToken() throws -> Token {
        let lex = tokens[indexToken]
        self.activityToken = lex
        indexToken += 1
        return lex
    }
    
    func openStack() throws {
        let item = StackItem()
        stack.append(item)
    }
    
    @discardableResult
    func closeStack() throws -> [ITreeItem] {
        try self.closeOperator(with: 0)
        let item = stack.removeLast()
        return item.items
    }
    
    func closeOperator(with priority: Int) throws {
        let item = try getStackItem()
        while let last = item.closeOperatorHandler.last, last.priority >= priority {
            let handler = item.closeOperatorHandler.removeLast().handler
            try handler(self)
        }
    }
    
    func closeOperatorHandler(with priority: Int, _ handler: @escaping (_ builder: TreeBuilder) throws -> Void) throws {
        let handler = CloseOperatorHandler(priority: priority, handler: handler)
        try getStackItem().closeOperatorHandler.append(handler)
    }
    
    func getStackItem() throws -> StackItem {
        guard let item = stack.last else {
            throw TreeBuilderError()
        }
        return item
    }
    
    func push(_ expression: ITreeExpression, position: Position? = nil, text: String? = nil) throws {
        let item = TreeItem(expression: expression, position: position ?? activityToken?.position, text: text ?? activityToken?.text)
        try getStackItem().items.append(item)
    }
    
    func create<Type: ITreeExpression>(_ expression: Type, position: Position? = nil, text: String? = nil) throws -> GenericTreeItem<Type> {
        return GenericTreeItem(expression: expression, position: position ?? activityToken?.position, text: text ?? activityToken?.text)
    }
    
    func pop() throws -> ITreeItem {
        try getStackItem().items.removeLast()
    }
    
    func node() throws -> TreeNode {
        fatalError()
    }
}

private extension TreeBuilder {
    func expression() throws {
        let token = try self.nextToken()
        switch token.type
        {
        case .if:
            try self.`if`()
        case .`else`:
            try self.`else`()
        case .bool(let value):
            try self.push(EF.bool(value))
        case .openCodeBlock:
            try startBlock()
        case .closeCodeBlock:
            try endBlock()
        case .pointOperator:
            try self.point()
        case .assignOperator:
            try self.assign()
        case .identifier(let identifier):
            try self.identifier(name: identifier)
        case .openFunctionArguments:
            try startArgument()
        case .closeFunctionArguments:
            try endArgument()
        case .separatorFunctionArguments:
            try separatorArgument()
        case .nameSeparatorFunctionArgument:
            try nameSeparatorArgument()
        case .return:
            try self.return()
        case .function:
            try function()
        case .space:
            return
        case .superEnd:
            try self.closeOperator(with: 0)
            try self.push(EF.skip)
        case .end:
            try self.closeOperator(with: 0)
            try self.push(EF.skip)
        case .number(let number):
            try self.push(EF.number(number))
        case .string(let text):
            try self.push(EF.string(text))
        case .binOperator(let id, let priority):
            try binOperator(id: id, priority: priority)
        case .for:
            break
        case .in:
            try self.closeOperator(with: 0)
            try self.push(EF.skip)
            break
        case .range:
            break
        case .error:
            return
        }
    }
    
}

private extension TreeBuilder {
    func binOperator(id: String, priority: Int) throws {
        try self.closeOperator(with: priority)
        let left = try self.pop()
        try self.closeOperatorHandler(with: priority) { builder in
            let right = try builder.pop()
            try builder.push(EF.binaryOperator(left: left, right: right, operator: id))
        }
    }
    
    func `if`() throws {
        let search = try self.search(type: BlockTreeExpression.self)
        guard search.items.count == 1 else {
            throw TreeBuilderError()
        }
        try self.push(EF.`if`(condition: search.items[0], block: search.result))
    }
    
    func `else`() throws {
        guard let ifExpression = try self.pop().if else {
            throw TreeBuilderError()
        }
        
        try self.openStack()
        let item = try self.getStackItem()
        while item.items.count < 1 {
            try self.expression()
        }
        let elseAction = try self.closeStack()[0]
        try self.push(EF.ifelse(ifExpression: ifExpression, elseAction: elseAction))
    }

    func identifier(name: String) throws {
        try self.push(EF.identifier(name))
    }
    
    func point() throws {
        try self.closeOperator(with: 1001)
        let expression = try self.pop()
        try self.closeOperatorHandler(with: 1001) { builder in
            guard let identifier = try builder.pop().identifier else {
                throw TreeBuilderError()
            }
            try builder.push(EF.point(expression: expression, identifier: identifier.expr.identifier))
        }
    }
    
    func assign() throws {
        try self.closeOperator(with: 1)
        let item = try self.pop()
        try self.closeOperatorHandler(with: 1) { builder in
            let right = try builder.pop()
            try builder.push(EF.assignOperator(varIdentifier: item, right: right))
        }
    }
    
    func `return`() throws {
        try self.closeOperatorHandler(with: 1) { builder in
            let expression = try builder.pop()
            try builder.push(EF.return(expression))
        }
    }
    
    //function()
    func function() throws {
        try self.openStack()
        let item = try self.getStackItem()
        while item.items.count < 1 {
            try self.expression()
        }
        let exp = try self.closeStack()[0]
        
        var identifier: GenericTreeItem<IdentifierTreeExpression>?
        var arguments: GenericTreeItem<ArgumentsTreeExpression>?
        if let id = exp.identifier {
            identifier = id
        } else {
            guard let args = exp.arguments else {
                throw TreeBuilderError()
            }
            arguments = args
        }
        
        try self.push(EF.declareFunction(
            identifier: identifier,
            arguments: arguments ?? self.next(),
            block: try self.next()
        ))
    }
    
    func search<ExpressionType: ITreeExpression>(type: ExpressionType.Type) throws -> (items: [ITreeItem], result: GenericTreeItem<ExpressionType>) {
        try self.openStack()
        let item = try self.getStackItem()
        while (item.items.last?.convert() as GenericTreeItem<ExpressionType>?) == nil {
            try self.expression()
        }
        var items = try self.closeStack()
        let last = items.removeLast()
        guard let expression = last.convert() as GenericTreeItem<ExpressionType>? else {
            throw TreeBuilderError()
        }
        return (items: items, result: expression)
    }

    func next<ExpressionType: ITreeExpression>() throws -> GenericTreeItem<ExpressionType> {
        let result = try self.search(type: ExpressionType.self)
        guard result.items.count == 0 else {
            throw TreeBuilderError()
        }
        return result.result
    }

    func startBlock() throws {
        try self.closeOperator(with: 0)
        try self.openStack()
    }
    
    func endBlock() throws {
        try self.closeOperator(with: 0)
        let expression = try self.closeStack()
        try self.push(EF.block(expression))
    }
    
    func startArgument() throws {
        try self.closeOperator(with: 1000)
        try self.openStack()
    }
    
    func endArgument() throws {
        try self.closeOperator(with: 0)
        let arguments = try self.closeStack().map { item -> GenericTreeItem<ArgumentNameTreeExpression> in
            guard let argument = item.argumentName else {
                return try self.create(EF.argumentName(identifier: "_", expression: item))
            }
            return argument
        }
        let argumentsExpression = EF.arguments(arguments: arguments)
        if let last = try self.getStackItem().items.last, last.skip == nil {
            try self.push(EF.runFunction(expression: try self.pop(), arguments: create(argumentsExpression)))
        } else {
            try self.push(argumentsExpression)
        }
    }
    
    func separatorArgument() throws {
        try self.closeOperator(with: 2)
    }
    
    func nameSeparatorArgument() throws {
        try self.closeOperator(with: 3)
        let item = try self.pop()
        guard let identifier = item.identifier else {
            throw TreeBuilderError()
        }
        try self.closeOperatorHandler(with: 3) { builder in
            let expression = try builder.pop()
            try builder.push(EF.argumentName(identifier: identifier.expr.identifier, expression: expression))
        }
    }
}

private extension TreeBuilder {
    enum TreeBuilderEnd: Error {
        case end
    }

    struct CloseOperatorHandler {
        let priority: Int
        let handler: (_ builder: TreeBuilder) throws -> Void
    }


    final class StackItem {
        var items: [TreeItem] = []
        var closeOperatorHandler: [CloseOperatorHandler] = []
    }
}
