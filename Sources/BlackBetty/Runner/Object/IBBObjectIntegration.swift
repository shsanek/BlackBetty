public protocol IBBObjectIntegration {
    init(_ scriptObject: IObject?) throws
    func scriptObject() throws -> IObject?
}

extension Int: IBBObjectIntegration {
    public init(_ scriptObject: IObject?) throws {
        guard let obj = scriptObject as? NumberObject else {
            throw SyntaxisError.error
        }
        self = Int(obj.value)
    }

    public func scriptObject() throws -> IObject? {
        return NumberObject(value: Double(self))
    }
}

extension Double: IBBObjectIntegration {
    public init(_ scriptObject: IObject?) throws {
        guard let obj = scriptObject as? NumberObject else {
            throw SyntaxisError.error
        }
        self = obj.value
    }

    public func scriptObject() throws -> IObject? {
        return NumberObject(value: self)
    }
}

extension Bool: IBBObjectIntegration {
    public init(_ scriptObject: IObject?) throws {
        guard let obj = scriptObject as? BoolObject else {
            throw SyntaxisError.error
        }
        self = obj.value
    }

    public func scriptObject() throws -> IObject? {
        return BoolObject(value: self)
    }
}

extension String: IBBObjectIntegration {
    public init(_ scriptObject: IObject?) throws {
        guard let obj = scriptObject as? StringObject else {
            throw SyntaxisError.error
        }
        self = obj.value
    }

    public func scriptObject() throws -> IObject? {
        return StringObject(value: self)
    }
}

public struct Empty: IBBObjectIntegration {
    public init() {
    }

    public init(_ scriptObject: IObject?) throws {
    }

    public func scriptObject() throws -> IObject? {
        return EmptyObject()
    }
}
