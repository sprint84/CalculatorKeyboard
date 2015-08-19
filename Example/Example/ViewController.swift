//
//  ViewController.swift
//  Example
//
//  Created by Guilherme Moura on 8/17/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit
import RFCalculatorKeyboard

class ViewController: UIViewController, RFCalculatorDelegate {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 300)
        let keyboard = RFCalculatorKeyboard(frame: frame)
        keyboard.delegate = self
        keyboard.showDecimal = true
        inputTextField.inputView = keyboard
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - RFCalculatorKeyboard delegate
    func calculator(calculator: RFCalculatorKeyboard, didChangeValue value: String) {
        inputTextField.text = value
    }
}

