//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Kamenko on 27.01.24.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        print(buttonText)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Та-дам!")
    }


}

