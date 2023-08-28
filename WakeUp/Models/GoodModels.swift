//
//  GoodModels.swift
//  WakeUp
//
//  Created by Nik Y on 27.08.2023.
//

import UIKit

enum GoodType {
    case background
    case style
}

enum GoodStatus: Int {
    case choosen = 0
    case bought = 1
    case locked = 2
    
    var color : UIColor {
        switch self {
        case .choosen:
            return .cyan
        case .bought:
            return .white
        case .locked:
            return .red
        }
    }
}
