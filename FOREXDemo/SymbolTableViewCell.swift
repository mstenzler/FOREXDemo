//
//  SymbolTableViewCell.swift
//  FOREXDemo
//
//  Created by Michael Stenzler on 3/9/19.
//  Copyright © 2019 Michael Stenzler. All rights reserved.
//

import UIKit

protocol SymbolTableViewCelldelegate: class {
    func symbolTableViewCellValueDidChange(_ cell: SymbolTableViewCell)
}

class SymbolTableViewCell: UITableViewCell {
    
    weak var delegate: SymbolTableViewCelldelegate?

    @IBOutlet weak var titleLabel: UILabel!
 
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBAction func favoriteSwitchValueChanged(_ sender: UISwitch) {
        delegate?.symbolTableViewCellValueDidChange(self)
    }
    
}
