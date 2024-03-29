//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Kamenko on 27.01.24.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
    case limitedNumber
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiplay = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
            
        case .substract:
            return number1 - number2
            
        case .multiplay:
            return number1 * number2
            
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    var calculations: [(expression: [CalculationHistoryItem], result: Double)] = []

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        if let labelText = label.text {
            let strippedText = labelText.replacingOccurrences(of: ",", with: "")
            if strippedText.count >= 8 {
                return
            }
        }
        
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
        if label.text == "0" {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
            else { return }
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLabelText()
              
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        
        resetLabelText()
        
    }
    
    @IBAction func calculateButtonPressed() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            
            label.text = try formatResult(result)
            calculations.append((calculationHistory, result))
        } catch CalculationError.limitedNumber {
            label.text = "Ошибка: макс. количество знаков 16"
            
        } catch {
            label.text = "Ошибка"
        }
        
        calculationHistory.removeAll()
        
    }
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var historyButton: UIButton!
    
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyButton.accessibilityIdentifier = "historyButton"
        // Do any additional setup after loading the view.
        
        resetLabelText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    
    
    @IBAction func showCalculationList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationsListVC = sb.instantiateViewController(identifier: "CalculationsListViewController")
        if let vc = calculationsListVC as? CalculationsListViewController {
            vc.calculations = calculations
        }
        
        navigationController?.pushViewController(calculationsListVC, animated: true)
    }
    
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else { break }
            
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    func resetLabelText() {
        label.text = "0"
    }
    
    func formatResult(_ result: Double) throws -> String {
            let resultString = numberFormatter.string(from: NSNumber(value: result)) ?? ""
            if let dotIndex = resultString.firstIndex(of: ",") {
                let digitsBeforeDot = resultString.distance(from: resultString.startIndex, to: dotIndex)
                if digitsBeforeDot > 16 {
                    throw CalculationError.limitedNumber
                }
            }
            return resultString
        }


}

