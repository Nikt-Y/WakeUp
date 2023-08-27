//
//  Types.swift
//  WakeUp
//
//  Created by Nik Y on 09.08.2023.
//

import UIKit

//TODO: звуки (10 мин), магазин (30 мин)

/* TODO: Занести:
    -все названия картинок
    -продолжительность перехода на новый день (goToTime & Bedroom.newDay)
    -диапазон времени для подъема (тип с 6 до 9 часов)
*/

// 390 844
let width: CGFloat = 390
let height: CGFloat = 844

let screenRect: CGRect = UIScreen.main.bounds

var screenSize: CGSize {
    let ratio: CGFloat = screenRect.height/screenRect.width
    
    let w: CGFloat = height / ratio
    let h: CGFloat = height
    return CGSize(width: w, height: h)
}

let highscoreKey = "highscore"
let balanceKey = "balance"
let bgKey = "bgKey"
let keyGoodBG1 = "BACKGROUND 1"
let keyGoodBG2 = "BACKGROUND 2"
