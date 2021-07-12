struct ExternalFunction: IFunction {
    var objectValue: Any {
        Empty()
    }
    
    let context: BBContext = BBContext(global: nil, superContext: nil)
    let block: (_ objects: [ObjectContainer]) throws -> IObject?
    let argumentsCount: Int?

    init(argumentsCount: Int? = nil, block: @escaping (_ objects: [ObjectContainer]) throws -> IObject?) {
        self.argumentsCount = argumentsCount
        self.block = block
    }

    func run(_ objects: [ObjectContainer]) throws -> ObjectContainer? {
        guard argumentsCount == nil || argumentsCount == objects.count else {
            throw SyntaxisError.error
        }
        return ObjectContainer(object: try block(objects))
    }
}
