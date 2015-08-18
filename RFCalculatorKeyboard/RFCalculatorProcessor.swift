//
//  RFCalculatorProcessor.swift
//  Pods
//
//  Created by Guilherme Moura on 8/17/15.
//
//

import UIKit

class RFCalculatorProcessor {
    var automaticDecimal = false {
        didSet {
            if automaticDecimal {
                previousOperand = resetOperand()
                currentOperand = resetOperand()
            }
        }
    }
    var previousOperand: String = "0"
    var currentOperand: String = "0"
    var storedOperator: CalculatorKey?
    var decimalDigit = 0
    
    
    func storeOperand(value: Int) -> String {
        var operand = "\(value)"
        if currentOperand == "0" {
            currentOperand = operand
        } else {
            currentOperand += operand
        }
        
        if automaticDecimal {
            currentOperand = currentOperand.stringByReplacingOccurrencesOfString(decimalSymbol(), withString: "")
            if currentOperand[currentOperand.startIndex] == "0" {
                currentOperand.removeAtIndex(currentOperand.startIndex)
            }
            currentOperand.splice(decimalSymbol(), atIndex: advance(currentOperand.endIndex, -2))
        }
        
        return currentOperand
    }
    
    func deleteLastDigit() -> String {
        currentOperand.removeAtIndex(currentOperand.endIndex.predecessor())
        
        if automaticDecimal {
            currentOperand = currentOperand.stringByReplacingOccurrencesOfString(decimalSymbol(), withString: "")
            if count(currentOperand) < 3 {
                currentOperand.insert("0", atIndex: currentOperand.startIndex)
            }
            currentOperand.splice(decimalSymbol(), atIndex: advance(currentOperand.endIndex, -2))
        }
        
        return currentOperand
    }
    
    func addDecimal() -> String {
        if currentOperand.rangeOfString(decimalSymbol()) == nil {
            currentOperand += decimalSymbol()
        }
        return currentOperand
    }
    
    func storeOperator(rawValue: Int) -> String {
        if storedOperator != nil && storedOperator != .Equal {
            computeFinalValue()
        }
        previousOperand = currentOperand
        currentOperand = resetOperand()
        storedOperator = CalculatorKey(rawValue: rawValue)!
        return previousOperand
    }
    
    func computeFinalValue() -> String {
        if storedOperator != .Equal {
            let value1 = (previousOperand as NSString).doubleValue
            let value2 = (currentOperand as NSString).doubleValue
            if let oper = storedOperator {
                var output = 0.0
                switch oper {
                case .Multiply:
                    output = value1 * value2
                case .Divide:
                    output = value1 / value2
                case .Subtract:
                    output = value1 - value2
                case .Add:
                    output = value1 + value2
                default:
                    break
                }
                currentOperand = formatValue(output)
            }
            previousOperand = resetOperand()
            storedOperator = .Equal
            return currentOperand
        }
        return ""
    }
    
    func clearAll() -> String {
        storedOperator = nil
        currentOperand = resetOperand()
        previousOperand = resetOperand()
        return currentOperand
    }
    
    private func decimalSymbol() -> String {
        return "."
    }
    
    private func resetOperand() -> String {
        var operand = "0"
        if automaticDecimal {
            operand = convertOperandToDecimals(operand)
        }
        return operand
    }
    
    private func convertOperandToDecimals(operand: String) -> String {
        return operand + ".00"
    }
    
    private func formatValue(value: Double) -> String {
        var raw = "\(value)"
        if automaticDecimal {
            raw = String(format: "%.2f", value)
            return raw
        } else {
            var end = raw.endIndex.predecessor()
            while raw[end] == "0" || String(raw[end]) == decimalSymbol() {
                raw.removeAtIndex(end)
                end = end.predecessor()
            }
            return raw
        }
    }
}
