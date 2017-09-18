//
//  CalculatorProcessor.swift
//  Pods
//
//  Created by Guilherme Moura on 8/17/15.
//
//

import UIKit

class CalculatorProcessor {
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
        let operand = "\(value)"
        if currentOperand == "0" {
            currentOperand = operand
        } else {
            currentOperand += operand
        }
        
        if storedOperator == .Equal {
            if automaticDecimal {
                currentOperand = previousOperand + operand
            } else {
                currentOperand = operand
            }
            storedOperator = nil
        }
        
        if automaticDecimal {
            currentOperand = currentOperand.replacingOccurrences(of: decimalSymbol(), with: "")
            if currentOperand[currentOperand.startIndex] == "0" {
                currentOperand.remove(at: currentOperand.startIndex)
            }
            let char = decimalSymbol()[decimalSymbol().startIndex]
            currentOperand.insert(char, at: currentOperand.index(currentOperand.startIndex, offsetBy: -2))
        }
        
        return currentOperand
    }
    
    func deleteLastDigit() -> String {
        if currentOperand.characters.count > 1 {
            currentOperand.remove(at: currentOperand.index(before: currentOperand.endIndex))
            
            if automaticDecimal {
                currentOperand = currentOperand.replacingOccurrences(of: decimalSymbol(), with: "")
                if currentOperand.characters.count < 3 {
                    currentOperand.insert("0", at: currentOperand.startIndex)
                }
                let char = decimalSymbol()[decimalSymbol().startIndex]
                currentOperand.insert(char, at: currentOperand.index(currentOperand.startIndex, offsetBy: -2))
            }
        } else {
            currentOperand = resetOperand()
        }
        
        return currentOperand
    }
    
    func addDecimal() -> String {
        if currentOperand.range(of: decimalSymbol()) == nil {
            currentOperand += decimalSymbol()
        }
        return currentOperand
    }
    
    func storeOperator(rawValue: Int) -> String {
        if storedOperator != nil && storedOperator != .Equal {
            previousOperand = computeFinalValue()
        } else if storedOperator == .Equal && rawValue == CalculatorKey.Equal.rawValue {
            return currentOperand
        } else {
            previousOperand = currentOperand
        }
        currentOperand = resetOperand()
        storedOperator = CalculatorKey(rawValue: rawValue)!
        return previousOperand
    }
    
    func computeFinalValue() -> String {
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
            case .Equal:
                return currentOperand
            default:
                break
            }
            currentOperand = formatValue(value: output)
        }
        previousOperand = resetOperand()
        storedOperator = .Equal
        return currentOperand
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
            operand = convertOperandToDecimals(operand: operand)
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
            var end = raw.index(before: raw.endIndex)
            var foundDecimal = false
            while end != raw.startIndex && (raw[end] == "0" || isDecimal(char: raw[end])) && !foundDecimal {
                foundDecimal = isDecimal(char: raw[end])
                raw.remove(at: end)
                end = raw.index(before: raw.endIndex)
            }
            return raw
        }
    }
    
    private func isDecimal(char: Character) -> Bool {
        return String(char) == decimalSymbol()
    }
}
