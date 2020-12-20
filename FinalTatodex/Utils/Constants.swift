//
//  Constants.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/12/20.
//

/// This minimize human error
let reuseIdentifier = "TatodexCell"

/// All app's controller
var tatodexController = TatodexController()
var infoController    = InfoController()

/// API Calling code
let service = Service()
var typeNameArray  = [String]()
var skillNameArray = [String]()

enum NetworkResponse: String {
    case badRequest = "Bad request"
    case noJSON = "You didn't get a JSON file"
    case failed = "Network request failed"
    case noData = "Response returned without data to decode"
}

/// Custom stuff
var languageClickChecker = false
var shinyClickChecker    = false
var themeClickCkecker    = false
let tatodexCell = TatodexCell()
let infoView    = InfoView()

