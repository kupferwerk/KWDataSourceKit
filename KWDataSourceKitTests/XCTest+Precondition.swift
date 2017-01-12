//
//  XCTest+Precondition.swift
//  KWDataSourceKit
//
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import Foundation
import XCTest
@testable import KWDataSourceKit

extension XCTestCase {
    func expectingPreconditionFailure(_ expectedMessage: String? = nil, block: () -> ()) {

        let expectation = self.expectation(description: "failing precondition")

        // Overwrite `precondition` with something that doesn't terminate but verifies it happened
        preconditionClosure = { (condition, message, file, line) in
            if !condition {
                expectation.fulfill()

                if let expectedMessage = expectedMessage {
                    XCTAssertEqual(message, expectedMessage, "precondition message didn't match")
                }
            }
        }

        block();

        // Verify precondition "failed"
        waitForExpectations(timeout: 0.0, handler: nil)

        // Reset precondition
        preconditionClosure = defaultPreconditionClosure
    }
}
