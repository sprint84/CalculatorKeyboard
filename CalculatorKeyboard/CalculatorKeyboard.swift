//
//  CalculatorKeyboard.swift
//  CalculatorKeyboard
//
//  Created by Guilherme Moura on 8/15/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

public protocol CalculatorDelegate: class {
    func calculator(_ calculator: CalculatorKeyboard, didChangeValue value: String)
}

enum CalculatorKey: Int {
    case zero = 1
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case decimal
    case clear
    case delete
    case multiply
    case divide
    case subtract
    case add
    case equal
}

open class CalculatorKeyboard: UIView {
    open weak var delegate: CalculatorDelegate?
    open var numbersBackgroundColor = UIColor(white: 0.97, alpha: 1.0) {
        didSet {
            adjustLayout()
        }
    }
    open var numbersTextColor = UIColor.black {
        didSet {
            adjustLayout()
        }
    }
    open var operationsBackgroundColor = UIColor(white: 0.75, alpha: 1.0) {
        didSet {
            adjustLayout()
        }
    }
    open var operationsTextColor = UIColor.white {
        didSet {
            adjustLayout()
        }
    }
    open var equalBackgroundColor = UIColor(red:0.96, green:0.5, blue:0, alpha:1) {
        didSet {
            adjustLayout()
        }
    }
    open var equalTextColor = UIColor.white {
        didSet {
            adjustLayout()
        }
    }
    
    open var showDecimal = true {
        didSet {
            processor.automaticDecimal = !showDecimal
            adjustLayout()
        }
    }
    
    var view: UIView!
    fileprivate var processor = CalculatorProcessor()
    
    @IBOutlet weak var zeroDistanceConstraint: NSLayoutConstraint!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    fileprivate func loadXib() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        adjustLayout()
        addSubview(view)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CalculatorKeyboard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        adjustButtonConstraint()
        return view
    }
    
    fileprivate func adjustLayout() {
        if viewWithTag(CalculatorKey.decimal.rawValue) != nil {
            adjustButtonConstraint()
        }
        
        for i in 1...CalculatorKey.decimal.rawValue {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.tintColor = numbersBackgroundColor
                button.setTitleColor(numbersTextColor, for: UIControlState())
            }
        }
        
        for i in CalculatorKey.clear.rawValue...CalculatorKey.add.rawValue {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.tintColor = operationsBackgroundColor
                button.setTitleColor(operationsTextColor, for: UIControlState())
                button.tintColor = operationsTextColor
            }
        }
        
        if let button = self.view.viewWithTag(CalculatorKey.equal.rawValue) as? UIButton {
            button.tintColor = equalBackgroundColor
            button.setTitleColor(equalTextColor, for: UIControlState())
        }
    }
    
    fileprivate func adjustButtonConstraint() {
        let width = UIScreen.main.bounds.width / 4.0
        zeroDistanceConstraint.constant = showDecimal ? width + 2.0 : 1.0
        layoutIfNeeded()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch (sender.tag) {
        case (CalculatorKey.zero.rawValue)...(CalculatorKey.nine.rawValue):
            let output = processor.storeOperand(sender.tag-1)
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.decimal.rawValue:
            let output = processor.addDecimal()
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.clear.rawValue:
            let output = processor.clearAll()
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.delete.rawValue:
            let output = processor.deleteLastDigit()
            delegate?.calculator(self, didChangeValue: output)
        case (CalculatorKey.multiply.rawValue)...(CalculatorKey.add.rawValue):
            let output = processor.storeOperator(sender.tag)
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.equal.rawValue:
            let output = processor.computeFinalValue()
            delegate?.calculator(self, didChangeValue: output)
            break
        default:
            break
        }
    }
}
