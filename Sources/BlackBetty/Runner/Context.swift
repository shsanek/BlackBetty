public final class BBContext {
    let superContext: BBContext?
    var classContext: BBContext?
    var vars: [String: ObjectContainer] = [:]
    let global: BBContext?

    public init(global: BBContext? = nil, superContext: BBContext? = .systemContext) {
        self.superContext = superContext
        vars = global?.vars ?? [:]
        for container in superContext?.vars ?? [:] {
            vars[container.key] = container.value
        }
        self.global = global
    }
     
    func fetch(name: String) -> ObjectContainer {
        if let obj = vars[name] {
            return obj
        }
        let obj = ObjectContainer()
        vars[name] = obj
        return obj
    }
}

public extension BBContext {
    func set(_ identifier: String, object: IObject) {
        self.fetch(name: identifier).object = object
    }

    func function<Result: IBBObjectIntegration>(_ identifier: String, block: @escaping () -> Result) {
        let function = ExternalFunction(argumentsCount: 0) { _ in
            return try block().scriptObject()
        }
        set(identifier, object: function)
    }
    
    func function<ARG1: IBBObjectIntegration, Result: IBBObjectIntegration>(_ identifier: String, block: @escaping ((ARG1)) -> Result) {
        let function = ExternalFunction(argumentsCount: 1) { objc in
            return try block((try ARG1(objc[0].object))).scriptObject()
        }
        set(identifier, object: function)
    }
    
    func function<ARG1: IBBObjectIntegration, ARG2: IBBObjectIntegration, Result: IBBObjectIntegration>(_ identifier: String, block: @escaping ((ARG1, ARG2)) -> Result) {
        let function = ExternalFunction(argumentsCount: 2) { objc in
            return try block((try ARG1(objc[0].object), try ARG2(objc[1].object))).scriptObject()
        }
        set(identifier, object: function)
    }
}
