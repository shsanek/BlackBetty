extension BBContext {
    public static var systemContext: BBContext {
        let context = BBContext(global: nil, superContext: nil)
        context.function("print") { (text: String) -> Empty in
            print("\(text)")
            return Empty()
        }
        context.set("Array", object: ExternalFunction(argumentsCount: nil, block: { objects in
            return ArrayObject(values: objects)
        }))
        return context
    }
}
