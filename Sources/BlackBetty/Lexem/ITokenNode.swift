protocol ITokenNode: AnyObject {
    func next(symbol: Character, result: TokenResult) -> ITokenNode?
}
