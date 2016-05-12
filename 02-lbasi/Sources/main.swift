import Foundation

enum TokenType {
    case Integer
    case Plus
    case Minus
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
    private var currentChar: Character?
    private var currentToken: Token<Any>

    init(text: String) {
        self.text = text
        self.pos = self.text.characters.startIndex
        self.currentChar = self.text[self.pos]
        self.currentToken = Token(type: TokenType.EOF)
    }

    private func advance() {
        self.pos = self.pos.successor()

        if (self.pos >= text.endIndex) {
            self.currentChar = nil
        } else {
            self.currentChar = text[self.pos]
        }
    }

    private func skipWhitespace() {
        while (self.currentChar != nil && self.currentChar != Character("")) {
            self.advance()
        }
    }

    private func integer() -> Int {
        var result: String = ""
        while (self.currentChar != nil && Int(String(currentChar)) != nil) {
            result += String(self.currentChar)
            self.advance()
        }
        return Int(result)!
    }

    private func getNextToken() throws -> Token<Any> {
        while (self.currentChar != nil) {
            if (self.currentChar == Character("")) {
                self.skipWhitespace()
                continue
            }

            if (Int(String(self.currentChar)) != nil) {
                return Token(type: TokenType.Integer, value: self.integer())
            }

            if (self.currentChar == "+") {
                return Token(type: TokenType.Plus)
            }

            if (self.currentChar == "-") {
                return Token(type: TokenType.Minus)
            }

            throw InterpreterError.UnknownToken
        }

        return Token(type: TokenType.EOF)
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

        let op = self.currentToken
        try self.eat(op.type)

        let right = self.currentToken.value as! Int
        try self.eat(TokenType.Integer)

        if (op.type == TokenType.Plus) {
            return String(left + right)
        } else {
            return String(left - right)
        }
    }
}

while (true) {
    print("calc > ", terminator: "")
    let response = readLine()
    let interpreter = Interpreter(text: response!)
    let result = try interpreter.expr()
    print(result)
}