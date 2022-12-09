//
//  UIViewControllerExt.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 09/12/2022.
//

import Foundation
import UIKit

extension APICaller{
    func slice(_ string: String, from startingIndex: Int, to endIndex: Int) -> String {
        let chosenString = string
        var start = chosenString.startIndex
        if start.hashValue != 0{
            start = chosenString.index(start, offsetBy: startingIndex)
        }
        let end = chosenString.index(start, offsetBy: endIndex)
        return String(chosenString[start...end])
    }
    
    func slice(_ string: String, from startingIndex: Int, to character: Character) -> String? {
        let chosenString = string
        var start = chosenString.startIndex
        if start.hashValue != 0{
            start = chosenString.index(start, offsetBy: startingIndex)
        }
        guard let end = chosenString.firstIndex(of: character)else{ return nil}
        return String(chosenString[start..<end])
    }

    func slice(_ string: String, from character: Character, to secondCharacter: Character) -> String? {
        let chosenString = string
        var start = chosenString.firstIndex(of: character)!
        start = chosenString.index(start, offsetBy: 1)
        guard let end = chosenString.firstIndex(of: secondCharacter)else{ return nil}
        return String(chosenString[start..<end])
    }
    
    
}

