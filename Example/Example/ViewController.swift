//
//  ViewController.swift
//  Example
//
//  Created by Guilherme Moura on 8/17/15.
//  Copyright (c) 2015 Reefactor, Inc. All rights reserved.
//

import UIKit
import CalculatorKeyboard

class ViewController: UIViewController, CalculatorDelegate {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
        let keyboard = CalculatorKeyboard(frame: frame)
        keyboard.delegate = self
        keyboard.showDecimal = true
        inputTextField.inputView = keyboard
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - RFCalculatorKeyboard delegate
    func calculator(_ calculator: CalculatorKeyboard, didChangeValue value: String) {
        inputTextField.text = value
    }
}

