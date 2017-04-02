//: Playground - noun: a place where people can play

import UIKit
import Runes
import Curry

var str = "Hello, playground"

func foo(x: Int, y: Int) -> Int? {
    return (x + y) % 2 == 0 ? (x + y) : nil
}

let x1 = Optional(8)
let y1 = Optional(6)
let result = curry(foo) <^> x1 <*> y1

let oi = (curry(foo) <^> x1)

let ei = oi.flatMap { oi in
    return oi(6)
}

ei



