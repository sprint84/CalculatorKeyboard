//
//  RFCalculatorProcessor.swift
//  Pods
//
//  Created by Guilherme Moura on 8/17/15.
//
//

import UIKit

class RFCalculatorProcessor {
    var automaticDecimal = false
    var previousOperand: Double = 0.0
    var currentOperand: Double = 0.0
    var storedOperator: CalculatorKey?
    var decimalDigit = 0
    
    func storeOperand(value: Int) -> Double {
        if storedOperator == .Equal {
            currentOperand = 0.0
            storedOperator = nil
            decimalDigit = 0
        }
        var newDigit = Double(value)
        if automaticDecimal {
            newDigit /= 100.0
        } else if decimalDigit > 0 {
            newDigit /= pow(10.0, Double(decimalDigit))
            decimalDigit++
        }
        
        var previousValue = currentOperand
        if automaticDecimal || decimalDigit == 0 {
            previousValue *= 10
        }
        currentOperand = previousValue + newDigit
        return currentOperand
    }
    
    func addDecimal() {
        decimalDigit = 1
    }
    
    func storeOperator(rawValue: Int) {
        if storedOperator != nil && storedOperator != .Equal {
            computeFinalValue()
        }
        previousOperand = currentOperand
        currentOperand = 0.0
        decimalDigit = 0
        storedOperator = CalculatorKey(rawValue: rawValue)!
    }
    
    func computeFinalValue() -> Double? {
        if storedOperator != .Equal {
            if let oper = storedOperator {
                var output = 0.0
                switch oper {
                case .Multiply:
                    output = previousOperand * currentOperand
                case .Divide:
                    output = previousOperand / currentOperand
                case .Subtract:
                    output = previousOperand - currentOperand
                case .Add:
                    output = previousOperand + currentOperand
                default:
                    break
                }
                currentOperand = output
            }
            previousOperand = 0.0
            storedOperator = .Equal
            decimalDigit = 0
            return currentOperand
        }
        return nil
    }
    
    func clearAll() -> Double {
        storedOperator = nil
        currentOperand = 0.0
        previousOperand = 0.0
        return currentOperand
    }
}
