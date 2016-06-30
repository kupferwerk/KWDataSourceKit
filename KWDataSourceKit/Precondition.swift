//
//  Precondition.swift
//  KWDataSourceKit
//
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import Foundation

/// A custom drop-in replacement `precondition`.
///
/// This will call Swift's `precondition` by default (and terminate the program).
/// But it can be changed at runtime to be tested instead of terminating.
func precondition(_ condition: @autoclosure() -> Bool, _ message: @autoclosure() -> String = "", file: StaticString = #file, line: UInt = #line) {
    preconditionClosure(condition(), message(), file, line)
}

/// The actual function called by our custom `precondition`.
var preconditionClosure: (Bool, String, StaticString, UInt) -> () = defaultPreconditionClosure
let defaultPreconditionClosure = { Swift.precondition($0, $1, file: $2, line: $3) }
