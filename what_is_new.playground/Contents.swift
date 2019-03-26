import UIKit
import Foundation

struct Person {
    var name: String
    var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}

// Mark: Raw String
let rain = #"The "rain" in "Spain" falls manly ono the Spaniards."#


let keypaths = #"Swift keypaths such as \Person.name hold uninvoked references to properties."#

let answer = 42
let dontpanic = #"The answer is \#(answer)."#
let panic = #"The answer is \(answer)"#

//let str = ##"My dog said "woof"#"gooddog"##

let multiline = #"""
The answer is is \#(answer)
"""#

let regex = #"\\[A-Z]+[A-z]+\.[a-z]+"#


// Mark: Standard Result type

enum NetworkError: Error {
    case badURL
}


func fetchUnreadCount1(from  urlString: String,
                       completionHandler: @escaping (Result<Int,  NetworkError>) -> Void ) {
    guard let url = URL(string: urlString) else {
        completionHandler(.failure(.badURL))
        return
    }
    
    // complecated networking code here
    print("Fetching \(url.absoluteString)...")
    completionHandler(.success(5))
}



func resultInit() {
    
    fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
        switch result {
        case .success(let count):
            print("\(count) unread message.")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
        if let count = try? result.get() {
            print("\(count) unread messages.")
        }
    }
    
    let result = Result { try String(contentsOfFile: "tutorial.jpg") }
    
    switch result {
    case .success(let content):
        print(content)
    case .failure(let error):
        print(error.localizedDescription)
    }
}

// Mark: Customizing string interpolation
struct User {
    var name: String
    var age: Int
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: User) {
        appendLiteral("My name is \(value.name) and I'm \(value.age)")
    }
}

func userPrint() {
    let user = User(name: "A", age: 40)
    print("User details: \(user)")
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ number: Int, style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        
        if let result = formatter.string(from: number as NSNumber) {
            appendLiteral(result)
        }
    }
}

func numberFormatter() {
    let number = Int.random(in: 0...100)
    let lucky = "The lucky number this week is \(number, style: .spellOut)"
    print(lucky)
}

extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0..<count {
            appendLiteral(str)
        }
    }
}

//print("Baby shark \(repeat: "doo ", 6)")


extension String.StringInterpolation {
    mutating func appendInterpolation(_ values: [String], empty defaultValue: @autoclosure() -> String) {
        if values.count == 0 {
            appendLiteral(defaultValue())
        } else {
            appendLiteral(values.joined(separator: ", "))
        }
    }
}


struct HTMLComponent: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    
    struct StringInterpolation: StringInterpolationProtocol {
        // start with an empty string
        var output = ""
        
        // allocate enough space to hold twice the amout of literal text
        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity * 2)
        }
        
        // a hard-coded piece of text - just add it
        mutating func appendLiteral(_ literal: String) {
            print("Appending \(literal)")
            output.append(literal)
        }
        
        // a twitter username - add it as a link
        mutating func appendInterpolation(twitter: String) {
            print("Appending \(twitter)")
            output.append("<a href=\"https://twitter/\(twitter)\">@\(twitter)</a>")
        }
        
        // an email address - add it using mailto
        mutating func appendInterpolation(email: String) {
            print("Appending \(email)")
            output.append("<a href=\"mailto:\(email)\">\(email)</a>")
        }
    }
    
    // finished text for this whole component
    let description: String
    
    // create an instance from a literal string
    init(stringLiteral value: String) {
        description = value
    }
    
    // create an instance from an interpolated string
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.output
    }
 }

let text: HTMLComponent = "You should follow me on Twitter \(twitter: "twostraws"), or you can email me at \(email: "paul@hackingwithswift.com")."

print(text)
