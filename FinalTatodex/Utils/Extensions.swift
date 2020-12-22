//
//  Extensions.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/5/20.
//

import UIKit
import Alamofire

//MARK: - Custom Colors
enum Colors {
    /// Main color palette
    static let mainWhite  = UIColor(hex: "#F5F5F5ff")
    static let mainBlack  = UIColor(hex: "#1C1C1Cff")
    static let lightRed   = UIColor(hex: "#DE3E3Eff")
    static let mainGray   = UIColor(hex: "#F3ECE7ff")
    static let darkRed    = UIColor(hex: "#BA3434ff")
    
    /// 1st optional color  palette
    static let darkBlue     = UIColor(hex: "#3479BAff")
    static let lightBlue    = UIColor(hex: "#3E8EDEff")
    
    static let softGreen    = UIColor(hex: "#5EC163ff")
    static let hardGreen    = UIColor(hex: "#359040ff")
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

//MARK: - View Layout
extension UIView {
    
    func center(inView view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

//MARK: Strings

extension String {

   func removingAllWhitespaces() -> String {
       return removingCharacters(from: .whitespaces)
   }

   func removingCharacters(from set: CharacterSet) -> String {
       var newString = self
       newString.removeAll { char -> Bool in
           guard let scalar = char.unicodeScalars.first else { return false }
           return set.contains(scalar)
       }
       return newString
   }
}

// MARK: - Buttons

extension UIButton {
    func configureCustomButton() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.layer.borderWidth = 3
        self.layer.borderColor = Colors.mainBlack?.cgColor
        self.tintColor = Colors.mainWhite
    }
}

//  MARK: - Quick layout
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat,
                bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat,
                left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat,
                right: NSLayoutXAxisAnchor?, paddingRight: CGFloat,
                width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top    = top {
            topAnchor.constraint(equalTo    : top,
                                 constant   : paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo : bottom,
                                    constant: -paddingBottom).isActive = true
        }
        if let right  = right {
            rightAnchor.constraint(equalTo  : right,
                                   constant : -paddingRight).isActive = true
        }
        if let left   = left {
            leftAnchor.constraint(equalTo   : left,
                                  constant  : paddingLeft).isActive = true
        }
        if width  != 0 {
            widthAnchor.constraint(equalToConstant  : width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant : height).isActive = true
        }
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {

    @discardableResult
    func responsePokemon(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<Pokemon>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSpecies(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<Species>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseResource(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<Resource>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseTypesOrSkills(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<TypesAndSkillsLanguage>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
}

