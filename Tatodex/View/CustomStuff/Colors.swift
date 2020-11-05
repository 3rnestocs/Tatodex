//
//  Colors.swift
//  PokemonViewer
//
//  Created by Ernesto Jose Contreras Lopez on 11/1/20.
//

import UIKit

enum Colors {
    static let softBlue     = UIColor(hex: "#5eb7c1ff")
    static let hardBlue     = UIColor(hex: "#358790ff")
    static let softRed      = UIColor(hex: "#C15E5Eff")
    static let hardRed      = UIColor(hex: "#903535ff")
    static let softGreen    = UIColor(hex: "#5EC163ff")
    static let hardGreen    = UIColor(hex: "#359040ff")
    static let myWhite      = UIColor(hex: "#F5F5F5ff")
    static let mainOrange   = UIColor(hex: "#EDA266ff")
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
