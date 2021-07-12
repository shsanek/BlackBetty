import XCTest
import BlackBetty

final class BlackBettyTests: XCTestCase {
    func test01() throws {
        XCTAssert(try BlackBetty.run("true")?.get() ?? false)
        XCTAssert((try BlackBetty.run("false")?.get()) == false)
        XCTAssert((try BlackBetty.run("10")?.get(Double.self)) == 10)
        XCTAssert(((try BlackBetty.run("10.5") as? NumberObject)?.value ?? 0) == 10.5)
        XCTAssert(((try BlackBetty.run("\"text\"") as? StringObject)?.value ?? "") == "text")
    }
    
    func test02() throws {
        XCTAssert((try BlackBetty.run("10 == 10") as? BoolObject)?.value ?? false)
        XCTAssert((try BlackBetty.run("25 != 10") as? BoolObject)?.value ?? false)
        XCTAssert((try BlackBetty.run("\"fact\"==\"fact\"") as? BoolObject)?.value ?? false)
        XCTAssert((try BlackBetty.run("\"fact1\"!=\"fact\"") as? BoolObject)?.value ?? false)
        XCTAssert((try BlackBetty.run("true != false") as? BoolObject)?.value ?? false)
        XCTAssert((try BlackBetty.run("false == false") as? BoolObject)?.value ?? false)
        XCTAssert((try BlackBetty.run("true == true") as? BoolObject)?.value ?? false)

        XCTAssert((try BlackBetty.run("10 + 10") as? NumberObject)?.value ?? 0 == 20)
        XCTAssert((try BlackBetty.run("20 - 10") as? NumberObject)?.value ?? 0 == 10)
        XCTAssert((try BlackBetty.run("10 * 2") as? NumberObject)?.value ?? 0 == 20)
        XCTAssert((try BlackBetty.run("20 / 2") as? NumberObject)?.value ?? 0 == 10)
    }
    
    func test03() throws {
        XCTAssert((try BlackBetty.run("2 + 2 * 2") as? NumberObject)?.value ?? 0 == 6)
        XCTAssert((try BlackBetty.run("(2 + 2) * 2") as? NumberObject)?.value ?? 0 == 8)
        XCTAssert((try BlackBetty.run("2 * 2 + 2") as? NumberObject)?.value ?? 0 == 6)
        XCTAssert((try BlackBetty.run("2 * (2 + 2)") as? NumberObject)?.value ?? 0 == 8)
    }
    
    func test04() throws {
        XCTAssert((try BlackBetty.run("if true { return 6 }") as? NumberObject)?.value ?? 0 == 6)
        XCTAssert((try BlackBetty.run("if false { return 0 } \n else { return 6 }") as? NumberObject)?.value ?? 0 == 6)
        XCTAssert((try BlackBetty.run("if 6 == 6 { return 6 }") as? NumberObject)?.value ?? 0 == 6)
        XCTAssert((try BlackBetty.run("if 6 != 6 { return 0 } \n else { return 6 }") as? NumberObject)?.value ?? 0 == 6)
    }
    
    func test05() throws {
        let script =
"""
func fact(number: Number) {
    currentNumber = number.toInt()
    if currentNumber == 0 {
        return 1
    }
    return fact(currentNumber - 1) * currentNumber
}
fact(4)
"""
        XCTAssert(((try BlackBetty.run(script) as? NumberObject)?.value ?? 0) == 24)
    }
    
    func test06() throws {
        let context = BBContext()
        context.function("getText") { () -> String in
            return "Hello world"
        }
        XCTAssert(try BlackBetty.run("getText()", context: context)?.get() == "Hello world")
    }
    
    func test07() throws {
        let context = BBContext()
        let result: [Double] = [3, 10, 13, 15]
        let scriptResult = try BlackBetty.run("list = Array(8, 10, 13); list.append(15); list(0) = 3; return list", context: context)
        XCTAssert(scriptResult?.get() == result)
    }
}
