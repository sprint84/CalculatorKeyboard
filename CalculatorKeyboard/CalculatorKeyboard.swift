//
//  CalculatorKeyboard.swift
//  CalculatorKeyboard
//
//  Created by Guilherme Moura on 8/15/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

public protocol CalculatorDelegate: class {
    func calculator(calculator: CalculatorKeyboard, didChangeValue value: String)
}

enum CalculatorKey: Int {
    case Zero = 1
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

public class CalculatorKeyboard: UIView {
    public weak var delegate: CalculatorDelegate?
    public var numbersBackgroundColor = UIColor(white: 0.97, alpha: 1.0) {
        didSet {
            adjustLayout()
        }
    }
    public var numbersTextColor = UIColor.blackColor() {
        didSet {
            adjustLayout()
        }
    }
    public var operationsBackgroundColor = UIColor(white: 0.75, alpha: 1.0) {
        didSet {
            adjustLayout()
        }
    }
    public var operationsTextColor = UIColor.whiteColor() {
        didSet {
            adjustLayout()
        }
    }
    public var equalBackgroundColor = UIColor(red:0.96, green:0.5, blue:0, alpha:1) {
        didSet {
            adjustLayout()
        }
    }
    public var equalTextColor = UIColor.whiteColor() {
        didSet {
            adjustLayout()
        }
    }
    
    public var showDecimal = true {
        didSet {
            processor.automaticDecimal = !showDecimal
            adjustLayout()
        }
    }
    
    var view: UIView!
    private var processor = CalculatorProcessor()
    
    @IBOutlet weak var zeroDistanceConstraint: NSLayoutConstraint!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    private func loadXib() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        adjustLayout()
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CalculatorKeyboard", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        adjustButtonConstraint()
        return view
    }
    
    private func adjustLayout() {
        if viewWithTag(CalculatorKey.Decimal.rawValue) != nil {
            adjustButtonConstraint()
        }
        
        for var i = 1; i <= CalculatorKey.Decimal.rawValue; i++ {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.tintColor = numbersBackgroundColor
                button.setTitleColor(numbersTextColor, forState: .Normal)
            }
        }
        
        for var i = CalculatorKey.Clear.rawValue; i <= CalculatorKey.Add.rawValue; i++ {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.tintColor = operationsBackgroundColor
                button.setTitleColor(operationsTextColor, forState: .Normal)
                button.tintColor = operationsTextColor
            }
        }
        
        if let button = self.view.viewWithTag(CalculatorKey.Equal.rawValue) as? UIButton {
            button.tintColor = equalBackgroundColor
            button.setTitleColor(equalTextColor, forState: .Normal)
        }
    }
    
    private func adjustButtonConstraint() {
        let width = UIScreen.mainScreen().bounds.width / 4.0
        zeroDistanceConstraint.constant = showDecimal ? width + 2.0 : 1.0
        layoutIfNeeded()
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        switch (sender.tag) {
        case (CalculatorKey.Zero.rawValue)...(CalculatorKey.Nine.rawValue):
            let output = processor.storeOperand(sender.tag-1)
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.Decimal.rawValue:
            let output = processor.addDecimal()
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.Clear.rawValue:
            let output = processor.clearAll()
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.Delete.rawValue:
            let output = processor.deleteLastDigit()
            delegate?.calculator(self, didChangeValue: output)
        case (CalculatorKey.Multiply.rawValue)...(CalculatorKey.Add.rawValue):
            let output = processor.storeOperator(sender.tag)
            delegate?.calculator(self, didChangeValue: output)
        case CalculatorKey.Equal.rawValue:
            let output = processor.computeFinalValue()
            delegate?.calculator(self, didChangeValue: output)
            break
        default:
            break
        }
    }
}
