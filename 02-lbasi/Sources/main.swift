import Foundation

enum TokenType {
    case Integer
    case Plus
    case EOF
}

class Token<T>: CustomStringConvertible {
    private let type: TokenType
    private let value: T?

    init(type: TokenType, value: T? = nil) {
        self.type = type
        self.value = value
    }

    var description: String {
        return "Token(\(self.type), \(self.value))"
    }
}

enum InterpreterError: ErrorProtocol {
    case UnknownToken
    case InvalidSyntax
}

class Interpreter {
    private let text: String
    private var pos: String.Index
    private var currentToken: Token<Any>

    init(text: String) {
        self.text = text
        self.pos = self.text.characters.startIndex
        self.currentToken = Token(type: TokenType.EOF)
    }

    private func getNextToken() throws -> Token<Any> {
        let text = self.text

        if (self.pos >= text.endIndex) {
            return Token(type: TokenType.EOF)
        }

        let currentChar = text[self.pos]

        if (Int(String(currentChar)) != nil) {
            self.pos = self.pos.successor()
            return Token(type: TokenType.Integer, value: Int(String(currentChar)))
        }

        if (currentChar == "+") {
            self.pos = self.pos.successor()
            return Token(type: TokenType.Plus)
        }

        throw InterpreterError.UnknownToken
    }

    private func eat(type: TokenType) throws {
        if (self.currentToken.type == type) {
            self.currentToken = try self.getNextToken()
        } else {
            throw InterpreterError.InvalidSyntax
        }
    }

    func expr() throws -> String {
        self.currentToken = try self.getNextToken()

        let left = self.currentToken.value as! Int
        try self.eat(TokenType.Integer)

        try self.eat(TokenType.Plus)

        let right = self.currentToken.value as! Int
        try self.eat(TokenType.Integer)

        return String(left + right)
    }
}

while (true) {
    print("calc > ", terminator: "")
    let response = readLine()
    let interpreter = Interpreter(text: response!)
    let result = try interpreter.expr()
    print(result)
}