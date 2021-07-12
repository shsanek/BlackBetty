final class SpaceTokenNode: ITokenNode {
    func next(symbol: Character, result: TokenResult) -> ITokenNode? {
        if symbol == " " || symbol == "\t" {
            return self
        }
        result.addToken(.space)
        return nil
    }
}
