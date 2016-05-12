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
        return "Token(\(type), \(value))"
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
        pos = pos.successor()

        if pos >= text.endIndex {
            currentChar = nil
        } else {
            currentChar = text[pos]
        }
    }

    private func skipWhitespace() {
        while (currentChar != nil && currentChar != Character("")) {
            advance()
        }
    }

    private func integer() -> Int {
        var result: String = ""
        while (currentChar != nil && Int(String(currentChar)) != nil) {
            result += String(currentChar)
            advance()
        }
        return Int(result)!
    }

    private func getNextToken() throws -> Token<Any> {
        while (currentChar != nil) {
            if currentChar == Character("") {
                skipWhitespace()
                continue
            }

            if Int(String(currentChar)) != nil {
                return Token(type: TokenType.Integer, value: integer())
            }

            if currentChar == "+" {
                return Token(type: TokenType.Plus)
            }

            if currentChar == "-" {
                return Token(type: TokenType.Minus)
            }

            throw InterpreterError.UnknownToken
        }

        return Token(type: TokenType.EOF)
    }

    private func eat(type: TokenType) throws {
        if currentToken.type == type {
            currentToken = try getNextToken()
        } else {
            throw InterpreterError.InvalidSyntax
        }
    }

    func expr() throws -> String {
        currentToken = try getNextToken()

        let left = currentToken.value as! Int
        try eat(TokenType.Integer)

        let op = currentToken
        try eat(op.type)

        let right = currentToken.value as! Int
        try eat(TokenType.Integer)

        if op.type == TokenType.Plus {
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