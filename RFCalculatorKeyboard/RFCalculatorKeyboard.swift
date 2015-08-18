//
//  RFCalculatorKeyboard.swift
//  RFCalculatorKeyboard
//
//  Created by Guilherme Moura on 8/15/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

public protocol RFCalculatorDelegate: class {
    func calculator(calculator: RFCalculatorKeyboard, didChangeValue value: Double)
}

enum CalculatorKey: Int {
    case Zero = 0
    case One
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
    case Decimal
    case Clear
    case Delete
    case Multiply
    case Divide
    case Subtract
    case Add
    case Equal
}

public class RFCalculatorKeyboard: UIView {
    public var showDecimal = false {
        didSet {
            processor.automaticDecimal = !showDecimal
            ajustLayout()
        }
    }
    
    var view: UIView!
    private var processor = RFCalculatorProcessor()
    public weak var delegate: RFCalculatorDelegate?
    
    @IBOutlet weak var zeroDistanceConstraint: NSLayoutConstraint!
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    private func loadXib() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        ajustLayout()
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CalculatorKeyboard", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    private func ajustLayout() {
        let view = viewWithTag(CalculatorKey.Decimal.rawValue)
        if let decimal = view {
            let width = UIScreen.mainScreen().bounds.width / 4.0
            zeroDistanceConstraint.constant = showDecimal ? width + 2.0 : 1.0
            layoutIfNeeded()
        }
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        let key = CalculatorKey(rawValue: sender.tag)!
        switch (sender.tag) {
        case (CalculatorKey.Zero.rawValue)...(CalculatorKey.Nine.rawValue):
            var output = processor.storeOperand(sender.tag)
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.Decimal.rawValue:
            processor.addDecimal()
        case CalculatorKey.Clear.rawValue:
            var output = processor.clearAll()
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.Delete.rawValue:
            var output = processor.deleteLastDigit()
            delegate?.calculator(self, didChangeValue: output)
        case (CalculatorKey.Multiply.rawValue)...(CalculatorKey.Add.rawValue):
            processor.storeOperator(sender.tag)
        case CalculatorKey.Equal.rawValue:
            var output = processor.computeFinalValue()
            if let out = output {
                delegate?.calculator(self, didChangeValue: out)
            }
            break
        default:
            break
        }
    }
}
