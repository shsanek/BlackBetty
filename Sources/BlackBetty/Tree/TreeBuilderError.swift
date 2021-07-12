struct TreeBuilderError: Error {
    let file: String
    let line: Int

    init(file: String = #file, line: Int = #line) {
        self.file = file
        self.line = line
    }
}
