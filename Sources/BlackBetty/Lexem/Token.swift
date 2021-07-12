public struct Token {
    let type: TokenType
    let position: Position
    let text: String
}

extension Token {
    public enum TokenType {
        case openCodeBlock
        case closeCodeBlock
        
        case pointOperator
        case assignOperator
        case identifier(_ identifier: String)
        
        case openFunctionArguments
        case closeFunctionArguments
        case separatorFunctionArguments
        case nameSeparatorFunctionArgument
        case bool(_ value: Bool)
        case `if`
        case `else`
        case `return`

        case binOperator(_ id: String, priority: Int)
        case function
        case space
        case end
        case superEnd
        
        case `for`
        case `in`
        case range

        case number(_ double: Double)
        case string(_ string: String)
        
        case error
    }
}
