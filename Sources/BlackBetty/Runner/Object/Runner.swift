public final class Runner {
    public var globalContext: BBContext
    
    init(context: BBContext) {
        globalContext = BBContext(global: nil, superContext: context)
    }
    
    public func run(_ items: [ITreeItem]) throws -> ObjectContainer? {
        do {
            return try run(globalContext, items)
        }
        catch SystemClose.return(let container) {
            return container
        } catch {
            throw error
        }
    }

    func run(_ currentContext: BBContext, _ items: [ITreeItem]) throws -> ObjectContainer? {
        var lastValue: ObjectContainer?
        try items.forEach { expression in
            do {
                lastValue = try expression.run(currentContext)
            }
            catch SystemClose.return(let container) {
                throw SystemClose.return(container)
            } catch {
                throw error
            }
        }
        return lastValue
    }
}

enum SystemClose: Error {
    case `return`(ObjectContainer?)
}

public enum SyntaxisError: Error {
    case error
}
