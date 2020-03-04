//
//  ReservedWord.swift
//  SwiftReservedWords
//
//  Created by Allan Wolff on 03/03/20.
//  Copyright © 2020 Allan Wolff. All rights reserved.
//

import Foundation

// Using a class here in this case, so when filtering, we can update the value since I have the reference in memory :)
class ReservedWord {
    var wordTitle: String
    var alreadyScored: Bool
    
    init(wordTitle: String, alreadyScored: Bool = false) {
        self.wordTitle = wordTitle
        self.alreadyScored = alreadyScored
    }
}
