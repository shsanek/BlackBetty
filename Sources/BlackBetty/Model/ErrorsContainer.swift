public struct BBErrorsContainer
{
    public var errors: [Error] = []

    public var bbErrors: [BBErrorInfo] {
        self.errors.compactMap { $0 as? BBError }.compactMap { error -> BBErrorInfo? in
            if case .error(let info) = error {
                return info
            }
            return nil
        }
    }
    
    public var resultError: Error? {
        if errors.count == 1 {
            return self.errors[0]
        }
        else {
            return BBError.container(self)
        }
    }
}

extension BBErrorsContainer
{
    mutating func `do`(_ block: () throws -> Void) {
        do {
            try block()
        }
        catch BBError.container(let container) {
            self.errors.append(contentsOf: container.errors)
        }
        catch {
            self.errors.append(error)
        }
    }

    mutating func addError(_ error: Error) {
        self.errors.append(error)
    }

    func throwIfNeeded() throws {
        if errors.isEmpty == false {
            if errors.count == 1 {
                throw self.errors[0]
            }
            else {
                throw BBError.container(self)
            }
        }
    }
}

extension BBErrorsContainer: CustomDebugStringConvertible
{
    public var debugDescription: String {
        return errors.map { "\($0)" }.joined(separator: "\n\n")
    }
}


public struct BBErrorInfo {
    public let description: String
    public let position: Position
    public let text: String
}

public enum BBError: Error
{
    case error(_ info: BBErrorInfo)
    case container(_ container: BBErrorsContainer)
}

extension BBError
{
    static func customError(
        position: Position,
        text: String,
        _ description: String
    ) -> Self {
        return .error(BBErrorInfo(description: description, position: position, text: text))
    }
}

extension BBError: CustomDebugStringConvertible
{
    public var debugDescription: String {
        switch self {
        case .error(let info):
            return "\(info)"
        case .container(let container):
            return "\(container)"
        }
    }
}
