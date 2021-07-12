public protocol IObject {
    var objectValue: Any { get }
    var context: BBContext { get }
}

extension IObject {
    public func get<Type>(_ type: Type.Type) -> Type? {
        return self.objectValue as? Type
    }
    
    public func get<Type>() -> Type? {
        return self.objectValue as? Type
    }
}

public protocol IFunction: IObject {
    func run(_ objects: [ObjectContainer]) throws -> ObjectContainer?
}

public final class Object: IObject {
    public let context: BBContext
    
    public var objectValue: Any {
        return Empty()
    }
    
    init(context: BBContext) {
        self.context = context
    }
}

public final class NumberObject: IObject {
    public let context: BBContext = BBContext(global: nil, superContext: nil)
    public var objectValue: Any {
        return value
    }
    public let value: Double

    internal init(value: Double) {
        self.value = value
        context.function("+") { [weak self] (a: Double) -> Double in
            return (self?.value ?? 0) + a
        }
        context.function("-") { [weak self] (a: Double) -> Double in
            return (self?.value ?? 0) - a
        }
        context.function("/") { [weak self] (a: Double) -> Double in
            return (self?.value ?? 0) / a
        }
        context.function("*") { [weak self] (a: Double) -> Double in
            return (self?.value ?? 0) * a
        }
        context.function("==") { [weak self] (a: Double) -> Bool in
            return (self?.value ?? 0) == a
        }
        context.function("!=") { [weak self] (a: Double) -> Bool in
            return (self?.value ?? 0) != a
        }
        context.function("toString") { [weak self] () -> String in
            return self.flatMap { "\($0.value)" } ?? "nil"
        }
        context.function("toInt") { [weak self] in
            return Double(Int(self?.value ?? 0))
        }
    }
}

public final class BoolObject: IObject {
    public let context: BBContext = BBContext(global: nil, superContext: nil)
    public let value: Bool
    
    public var objectValue: Any {
        return value
    }

    internal init(value: Bool) {
        self.value = value
        
        context.function("||") { [weak self] (a: Bool) -> Bool in
            return (self?.value ?? false) || a
        }
        context.function("&&") { [weak self] (a: Bool) -> Bool in
            return (self?.value ?? false) && a
        }
        context.function("==") { [weak self] (a: Bool) -> Bool in
            return (self?.value ?? false) == a
        }
        context.function("!=") { [weak self] (a: Bool) -> Bool in
            return (self?.value ?? false) != a
        }
        context.function("toString") { [weak self] () -> String in
            return self.flatMap { "\($0.value)" } ?? "nil"
        }
    }
}

public final class StringObject: IObject {
    public let context: BBContext = BBContext(global: nil, superContext: nil)
    public let value: String
    
    public var objectValue: Any {
        return value
    }

    internal init(value: String) {
        self.value = value
        
        context.function("+") { [weak self] (a: String) -> String in
            return (self?.value ?? "") + a
        }
        context.function("==") { [weak self] (a: String) -> Bool in
            return (self?.value) == a
        }
        context.function("!=") { [weak self] (a: String) -> Bool in
            return (self?.value) != a
        }
    }
}

public final class EmptyObject: IObject {
    public let context: BBContext = BBContext(global: nil, superContext: nil)

    public var objectValue: Any {
        return Empty()
    }

    internal init() {
    }
}

public final class ArrayObject: IFunction {
    public let context: BBContext = BBContext(global: nil, superContext: nil)
    public var values = [ObjectContainer]()
    
    public var objectValue: Any {
        return values.map { $0.object?.objectValue }
    }

    internal init(values: [ObjectContainer]) {
        self.values = values
        context.function("append") { [weak self] (value: ObjectContainer) -> Empty in
            self?.values.append(value)
            return Empty()
        }
        context.function("insert") { [weak self] (index: Int, value: ObjectContainer) -> Empty in
            self?.values.insert(value, at: index)
            return Empty()
        }
        context.function("remove") { [weak self] (index: Int) -> Empty in
            self?.values.remove(at: index)
            return Empty()
        }
        context.function("toString") { [weak self] () -> String in
            return "\(self?.values ?? [])"
        }
    }
    
    public func run(_ objects: [ObjectContainer]) throws -> ObjectContainer? {
        guard objects.count == 1, let indexDouble = (objects[0].object as? NumberObject)?.value else {
            throw SyntaxisError.error
        }
        let index = Int(indexDouble)
        return values[index]
    }
}
