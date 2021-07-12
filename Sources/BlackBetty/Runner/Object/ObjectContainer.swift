public final class ObjectContainer {
    public var object: IObject?
    
    private var retaint: [IObject] = []

    init(object: IObject? = nil) {
        self.object = object
    }

    func retaint(_ object: IObject?) -> Self {
        object.flatMap { self.retaint.append($0) }
        return self
    }
}

extension ObjectContainer: IBBObjectIntegration {
    public convenience init(_ scriptObject: IObject?) throws {
        self.init(object: scriptObject)
    }
    
    public func scriptObject() throws -> IObject? {
        return self.object
    }
}
