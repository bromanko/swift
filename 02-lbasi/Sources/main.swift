import Foundation

enum TokenType {
    case Integer
    case Plus
    case EOF
}

class Token: CustomStringConvertible {
    private let type: TokenType;
    private let value: AnyObject;

    init(type: TokenType, value: AnyObject) {
        self.type = type;
        self.value = value;
    }

    var description: String {
        return "Token(\(self.type), \(self.value))"
    }
}

let token = Token(type: TokenType.Integer, value: 2)
print(token)