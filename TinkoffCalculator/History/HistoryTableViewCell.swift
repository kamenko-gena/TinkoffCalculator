//
//  HistoryTableViewCell.swift
//  TinkoffCalculator
//
//  Created by Kamenko on 30.01.24.
//

import Foundation
import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var expressionLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    func configure(with expressio: String, result: String) {
        expressionLabel.text = expressio
        resultLabel.text = result
        
    }
}
