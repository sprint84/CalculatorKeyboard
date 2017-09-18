//
//  CalculatorKeyboard.swift
//  CalculatorKeyboard
//
//  Created by Guilherme Moura on 8/15/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

public protocol CalculatorDelegate: class {
    func calculator(_: CalculatorKeyboard, didChangeValue value: String)
}

enum CalculatorKey: Int {
    case Sign
    case Zero
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
    public var numbersTextColor = UIColor.black {
        didSet {
            adjustLayout()
        }
    }
    public var operationsBackgroundColor = UIColor(white: 0.75, alpha: 1.0) {
        didSet {
            adjustLayout()
        }
    }
    public var operationsTextColor = UIColor.white {
        didSet {
            adjustLayout()
        }
    }
    public var equalBackgroundColor = UIColor(red:0.96, green:0.5, blue:0, alpha:1) {
        didSet {
            adjustLayout()
        }
    }
    public var equalTextColor = UIColor.white {
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
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    private func loadXib() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        adjustLayout()
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CalculatorKeyboard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        adjustButtonConstraint()
        return view
    }
    
    private func adjustLayout() {
        if viewWithTag(CalculatorKey.Decimal.rawValue) != nil {
            adjustButtonConstraint()
        }
        
        for i in 1...CalculatorKey.Decimal.rawValue {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.tintColor = numbersBackgroundColor
                button.setTitleColor(numbersTextColor, for: .normal)
            }
        }
        
        for i in CalculatorKey.Clear.rawValue...CalculatorKey.Add.rawValue {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.tintColor = operationsBackgroundColor
                button.setTitleColor(operationsTextColor, for: .normal)
                button.tintColor = operationsTextColor
            }
        }
        
        if let button = self.view.viewWithTag(CalculatorKey.Equal.rawValue) as? UIButton {
            button.tintColor = equalBackgroundColor
            button.setTitleColor(equalTextColor, for: .normal)
        }
    }
    
    private func adjustButtonConstraint() {
        let width = UIScreen.main.bounds.width / 4.0
        zeroDistanceConstraint.constant = showDecimal ? width + 2.0 : 1.0
        layoutIfNeeded()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch (sender.tag) {
        case CalculatorKey.Sign.rawValue:
            let output = processor.toggleSign()
            delegate?.calculator(self, didChangeValue: output)
        case (CalculatorKey.Zero.rawValue)...(CalculatorKey.Nine.rawValue):
            let output = processor.storeOperand(value: sender.tag - 1)
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
            let output = processor.storeOperator(rawValue: sender.tag)
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
