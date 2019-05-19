//
//  Theme.swift
//  GuiltyBox
//
//  Created by rshier on 19/05/19.
//  Copyright © 2019 rshier. All rights reserved.
//

import Foundation
import UIKit

enum Color: Int {
    case primary = 0xE75D79
    case secondary = 0x617D71
    
    func get() -> UIColor {
        return UIColor(rgb: self.rawValue)
    }
}
