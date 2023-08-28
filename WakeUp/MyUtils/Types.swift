//
//  Types.swift
//  WakeUp
//
//  Created by Nik Y on 09.08.2023.
//

import UIKit

//TODO:  картинки фазы и босс текст

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
let styleKey = "styleKey"

// goods
let keyBgSunrise1 = "Sunrise 1"
let keyBgSunrise2 = "Sunrise 2"
let keyBgFutureCity = "Future City"
let keyBgCyberCity = "Cyber City"
let keyBgNightCity = "Night City"

let keyStyleDefault = "Default bedrooms"
let keyStyleNight = "Night bedrooms"
let keyStyleEmpty = "Empty bedrooms"
let keyStyleSunrise = "Sunrise bedrooms"
let keyStyleRandom = "Random bedrooms"
