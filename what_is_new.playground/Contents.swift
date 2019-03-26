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

let str = ##"My dog said "woof"#"gooddog"##

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

func printUser() {
    let user = User(name: "A", age: 40)
    print("User details: \(user)")
}
