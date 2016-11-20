//
//  CalculatorProcessorTests.swift
//  RFCalculatorKeyboard
//
//  Created by Guilherme Moura on 8/18/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit
import XCTest
@testable import CalculatorKeyboard

class CalculatorProcessorTests: XCTestCase {
    var processor: CalculatorProcessor!
    
    override func setUp() {
        super.setUp()
        processor = CalculatorProcessor()
    }
    
    override func tearDown() {
        processor = nil
        super.tearDown()
    }

    func testAddOperand() {
        var output = processor.storeOperand(8)
        XCTAssertEqual("8", output, "")
        output = processor.storeOperand(4)
        XCTAssertEqual("84", output, "")
    }
    
    func testAutomaticDecimal() {
        processor.automaticDecimal = true
        var output = processor.storeOperand(8)
        XCTAssertEqual("0.08", output, "")
        output = processor.storeOperand(4)
        XCTAssertEqual("0.84", output, "")
    }
    
    func testAddDecimal() {
        processor.storeOperand(1)
        var output = processor.addDecimal()
        XCTAssertEqual("1.", output, "")
        output = processor.storeOperand(2)
        XCTAssertEqual("1.2", output, "")
        output = processor.addDecimal()
        XCTAssertEqual("1.2", output, "")
    }
    
    func testDeleteDigit() {
        processor.storeOperand(3)
        processor.storeOperand(5)
        let output = processor.deleteLastDigit()
        XCTAssertEqual("3", output, "")
    }
    
    func testDeleteLastDecimalDigit() {
        processor.automaticDecimal = true
        processor.storeOperand(3)
        processor.storeOperand(5)
        let output = processor.deleteLastDigit()
        XCTAssertEqual("0.03", output, "")
    }
    
    func testAddOperator() {
        processor.storeOperand(2)
        processor.storeOperand(0)
        var output = processor.storeOperator(CalculatorKey.add.rawValue)
        XCTAssertEqual("20", output, "")
        output = processor.storeOperand(5)
        XCTAssertEqual("5", output, "")
        output = processor.storeOperator(CalculatorKey.add.rawValue)
        XCTAssertEqual("25", output, "")
    }
    
    func testAddOperatorDecimal() {
        processor.automaticDecimal = true
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(5)
        let output = processor.storeOperand(0)
        XCTAssertEqual("0.50", output, "")
    }
    
    func testSubtractOperator() {
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.subtract.rawValue)
        processor.storeOperand(2)
        processor.storeOperand(0)
        let output = processor.computeFinalValue()
        XCTAssertEqual("0", output, "")
    }
    
    func testComputeFinalValue() {
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(8)
        processor.storeOperand(0)
        let output = processor.computeFinalValue()
        XCTAssertEqual("100", output, "")
    }
    
    func testComputeFinalValueDecimal() {
        processor.automaticDecimal = true
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperand(5)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(4)
        processor.storeOperand(7)
        processor.storeOperand(0)
        processor.storeOperand(0)
        let output = processor.computeFinalValue()
        XCTAssertEqual("67.50", output, "")
    }
    
    func testComputeFinalValueMutipleTimes() {
        processor.storeOperand(2)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(3)
        var output = processor.computeFinalValue()
        XCTAssertEqual("5", output, "")
        output = processor.computeFinalValue()
        XCTAssertEqual("5", output, "")
    }
    
    func testClearAfterComputeFinalValue() {
        processor.storeOperand(2)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(3)
        processor.computeFinalValue()
        processor.storeOperand(8)
        var output = processor.storeOperand(3)
        XCTAssertEqual("83", output, "")
        output = processor.storeOperator(CalculatorKey.add.rawValue)
        XCTAssertEqual("83", output, "")
        processor.storeOperand(1)
        processor.storeOperand(4)
        output = processor.computeFinalValue()
        XCTAssertEqual("97", output, "")
    }
    
    func testDigitAfterComputeFinalValue() {
        processor.automaticDecimal = true
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperand(5)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(4)
        processor.storeOperand(7)
        processor.storeOperand(0)
        processor.storeOperand(0)
        var output = processor.computeFinalValue()
        XCTAssertEqual("67.50", output, "")
        processor.storeOperand(4)
        processor.storeOperand(7)
        processor.storeOperand(0)
        processor.storeOperand(0)
        output = processor.computeFinalValue()
        XCTAssertEqual("47.00", output, "")
    }
    
    func testOperatorAfterComputeFinalValue() {
        processor.storeOperand(2)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(3)
        processor.computeFinalValue()
        var output = processor.storeOperator(CalculatorKey.add.rawValue)
        XCTAssertEqual("5", output, "")
        processor.storeOperand(4)
        output = processor.computeFinalValue()
        XCTAssertEqual("9", output, "")
    }
    
    func testConsecutiveOperations() {
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(1)
        processor.storeOperand(6)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(3)
        let output = processor.computeFinalValue()
        XCTAssertEqual("39", output, "")
    }
    
    func testClearAll() {
        processor.storeOperand(1)
        processor.storeOperand(5)
        processor.storeOperator(CalculatorKey.add.rawValue)
        processor.storeOperand(2)
        processor.storeOperand(3)
        var output = processor.clearAll()
        XCTAssertEqual("0", output, "")
        output = processor.storeOperand(4)
        XCTAssertEqual("4", output, "")
    }
}
