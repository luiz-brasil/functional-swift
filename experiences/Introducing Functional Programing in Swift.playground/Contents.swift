//: Playground - Introducing Functional Programing in Swift
//Created by: Luiz Alberto da Silva Oliveira
//Twitter: @luigledr
//Based on: http://fsharpforfunandprofit.com/posts/stack-based-calculator/

import Foundation

// Types
typealias ArithmeticFunction = (Float, Float) -> Float
typealias Stack = [Float]

enum StackError: ErrorType {
    case Empty
}

//Currying
func push(x: Float) -> (Stack) -> Stack {
    return { (content: Stack) -> Stack in
        var _content = content
        _content.append(x)
        return _content
    }
}

//Lambdas
func pop(contents: Stack) throws -> (head: Float, tail: Stack) {
    var _contents = contents
    
    guard let last = _contents.first else { throw StackError.Empty }
    
    _contents.removeFirst()
    
    return (head: last, tail: _contents)
}

infix operator |> { precedence 50 associativity left }

public func |> <T, U>(lhs: T, rhs: T -> U) -> U {
    return rhs(lhs)
}

//Patial Functions
let Empty = Stack()
let Zero = push(0.0)
let One = push(1.0)
let Two = push(2.0)
let Three = push(3.0)
let Four = push(4.0)
let Five = push(5.0)
let Six = push(6.0)
let Seven = push(7.0)
let Eight = push(8.0)
let Nine = push(9.0)

func binary(mathFn: ArithmeticFunction) -> (Stack) -> Stack {
    return { (content: Stack) in
        do {
            let opRight = try pop(content)
            let opLeft = try pop(opRight.tail)
            
            return push(mathFn(opRight.head, opLeft.head))(opLeft.tail)
        } catch {
            return Empty
        }
    }
}

func unary(fn: (Float) -> Float) -> (Stack) -> Stack {
    return { (content: Stack) in
        do {
            let value = try pop(content)
            
            return push(fn(value.head))(value.tail)
        } catch {
            return Empty
        }
    }
}

let add = binary(+)
let mul = binary(*)
let div = binary(/)
let sub = binary(-)
let neg = unary { (x) in return -x }
let square = unary { (x) in return x * x }

let stack1 = One(Empty)
let stack2 = Two(stack1)
let stack3 = add(stack2)

let stack4 = add(Two(One(Empty)))

let stack5 = Empty |> Two |> neg |> square |> Five |> mul
