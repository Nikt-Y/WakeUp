//
//  BedroomModels.swift
//  WakeUp
//
//  Created by Nik Y on 07.08.2023.
//

import UIKit

enum Status: String {
    case excellent = "EXCELLENT"
    case good = "GOOD"
    case nearly = "NEARLY"
    case overslept = "OVERSLEPT"
    case early = "TOO EARLY"
    case bad = "BAD"
    
    var color : UIColor {
        switch self {
        case .excellent:
            return .green
        case .good:
            return .init(hex: 0xDBFF01)
        case .nearly:
            return .yellow
        case .overslept, .bad, .early:
            return .red
        }
    }
}

enum MovementDirection {
    case left, right
}

