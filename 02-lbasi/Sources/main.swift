import Foundation

enum TokenType {
    case Integer
    case Plus
    case EOF
}

class Token: CustomStringConvertible {
    private let type: TokenType
    private let value: AnyObject?

    init(type: TokenType, value: AnyObject? = nil) {
        self.type = type
        self.value = value
    }

    var description: String {
        return "Token(\(self.type), \(self.value))"
    }
}

enum InterpreterError: ErrorProtocol {
    case CannotParse
}

class Interpreter {
    private let text: String
    private var pos: String.Index
    private var currentToken: Token? = nil

    init(text: String) {
        self.text = text
        self.pos = self.text.characters.startIndex
    }

    private func getNextToken() throws -> Token {
        let text = self.text

//        if (self.pos.successor() > text.characters.count - 1) {
//            return Token(type: TokenType.EOF)
//        }

        let currentChar = text[self.pos]

        throw InterpreterError.CannotParse
    }

    func expr() -> String {
        return "hi"
    }
}


let response = readLine(strippingNewline: true)
let interpreter = Interpreter(text: response!)
let result = interpreter.expr()
print(result)