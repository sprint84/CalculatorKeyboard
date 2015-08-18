//
//  RFCalculatorProcessorTests.swift
//  RFCalculatorKeyboard
//
//  Created by Guilherme Moura on 8/18/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit
import XCTest

class RFCalculatorProcessorTests: XCTestCase {
    var processor: RFCalculatorProcessor!
    
    override func setUp() {
        super.setUp()
        processor = RFCalculatorProcessor()
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
        var output = processor.deleteLastDigit()
        XCTAssertEqual("3", output, "")
    }
    
    func testDeleteLastDecimalDigit() {
        processor.automaticDecimal = true
        processor.storeOperand(3)
        processor.storeOperand(5)
        var output = processor.deleteLastDigit()
        XCTAssertEqual("0.03", output, "")
    }
    
    func testAddOperator() {
        processor.storeOperand(2)
        processor.storeOperand(0)
        var output = processor.storeOperator(CalculatorKey.Add.rawValue)
        XCTAssertEqual("20", output, "")
        output = processor.storeOperand(5)
        XCTAssertEqual("5", output, "")
        output = processor.storeOperator(CalculatorKey.Add.rawValue)
        XCTAssertEqual("25", output, "")
    }
    
    func testAddOperatorDecimal() {
        processor.automaticDecimal = true
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.Add.rawValue)
        processor.storeOperand(5)
        var output = processor.storeOperand(0)
        XCTAssertEqual("0.50", output, "")
    }
    
    func testComputeFinalValue() {
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.Add.rawValue)
        processor.storeOperand(3)
        processor.storeOperand(5)
        var output = processor.computeFinalValue()
        XCTAssertEqual("55", output, "")
    }
    
    func testComputeFinalValueDecimal() {
        processor.automaticDecimal = true
        processor.storeOperand(2)
        processor.storeOperand(0)
        processor.storeOperand(5)
        processor.storeOperand(0)
        processor.storeOperator(CalculatorKey.Add.rawValue)
        processor.storeOperand(4)
        processor.storeOperand(7)
        processor.storeOperand(0)
        processor.storeOperand(0)
        var output = processor.computeFinalValue()
        XCTAssertEqual("67.50", output, "")
    }
    
    func testClearAll() {
        processor.storeOperand(1)
        processor.storeOperand(5)
        processor.storeOperator(CalculatorKey.Add.rawValue)
        processor.storeOperand(2)
        processor.storeOperand(3)
        var output = processor.clearAll()
        XCTAssertEqual("0", output, "")
        output = processor.storeOperand(4)
        XCTAssertEqual("4", output, "")
    }
}
