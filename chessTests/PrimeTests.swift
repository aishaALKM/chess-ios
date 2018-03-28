//
//  PrimeTests.swift
//  chessTests
//
//  Created by Bowen Lin on 2018-03-25.
//  Copyright © 2018 GoldThumb Inc. All rights reserved.
//

import XCTest

class PrimeTests: XCTestCase {
    
    func testIsPrime() {
//        XCTAssertTrue(isPrime(x: 1))
        XCTAssertTrue(isPrime(x: 13))
        XCTAssertFalse(isPrime(x: 14))
        XCTAssertTrue(isPrime(x: 2))
        XCTAssertTrue(isPrime(x: 137153))
        XCTAssertFalse(isPrime(x: 14))
        XCTAssertTrue(isPrime(x: 30303030303031))
    }
    
    func isPrime(x: Int) -> Bool {
//        assert(x > 1, "Error")
        
        if x == 2 {
            return true
        }
        let squareRoot = sqrt(Double(x))
        let intSquareRoot = Int(squareRoot)
        
        for i in 2 ... intSquareRoot + 1 {
            if x % i == 0 {
                return false
            }
        }
        return true
    }
    
    func testSquareRoot() {
        let i = Double(30303030303031)
        let result = sqrt(i)
        let intResult = Int(result)
        print(intResult)
        print(result)
    }

}