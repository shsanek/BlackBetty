final class IdentifaerTokenNode: ITokenNode {
    static let startSymbols = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_"
    static let allSymbols = startSymbols + "1234567890"

    func next(symbol: Character, result: TokenResult) -> ITokenNode? {
        if IdentifaerTokenNode.allSymbols.contains(symbol) {
            return IdentifaerTokenNode()
        }
        if result.currentText == "else" {
            result.addToken(.else)
        } else if result.currentText == "if" {
            result.addToken(.if)
        } else if result.currentText == "true" {
            result.addToken(.bool(true))
        } else if result.currentText == "false" {
            result.addToken(.bool(false))
        } else if result.currentText == "func" {
            result.addToken(.function)
        } else if result.currentText == "return" {
            result.addToken(.return)
        } else if result.currentText == "for" {
            result.addToken(.for)
        } else if result.currentText == "in" {
            result.addToken(.in)
        } else {
            result.addToken(.identifier(result.currentText))
        }
        return nil
    }
}
