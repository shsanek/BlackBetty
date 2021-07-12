final class CustomFunction: IFunction {
    var objectValue: Any {
        Empty()
    }
    let context: BBContext = BBContext(global: nil, superContext: nil)
    
    weak var globalContext: BBContext?
    weak var functionContext: BBContext?
    let runner = Runner(context: BBContext())
    let arguments: [String]
    let expressions: [ITreeItem]

    init(arguments: [(String, ITreeItem)], block: [ITreeItem], context: BBContext) {
        self.globalContext = context.global
        self.arguments = arguments.map { $0.0 }
        self.functionContext = context
        self.expressions = block
    }
    
    func run(_ objects: [ObjectContainer]) throws -> ObjectContainer? {
        guard let functionContext = functionContext else {
            return nil
        }
        let context = BBContext(global: globalContext, superContext: functionContext)
        guard arguments.count == objects.count else {
            throw SyntaxisError.error
        }
        for i in 0..<arguments.count {
            context.fetch(name: arguments[i]).object = objects[i].object
        }
        do {
            _ = try runner.run(context, expressions)
        }
        catch SystemClose.return(let container) {
            return container
        }
        catch {
            throw error
        }
        return nil
    }
}
