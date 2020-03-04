//
//  ReservedWordsViewModel.swift
//  SwiftReservedWords
//
//  Created by Allan Wolff on 03/03/20.
//  Copyright © 2020 Allan Wolff. All rights reserved.
//

import Foundation

class ReservedWordsViewModel {
    private var listOfWords: [ReservedWord] = []
    
    public func populateList() {
        listOfWords.append(ReservedWord(wordTitle: "self"))
        listOfWords.append(ReservedWord(wordTitle: "typealias"))
        listOfWords.append(ReservedWord(wordTitle: "guard"))
        listOfWords.append(ReservedWord(wordTitle: "protocol"))
        listOfWords.append(ReservedWord(wordTitle: "let"))
        listOfWords.append(ReservedWord(wordTitle: "optional"))
        listOfWords.append(ReservedWord(wordTitle: "mutating"))
        listOfWords.append(ReservedWord(wordTitle: "enum"))
        listOfWords.append(ReservedWord(wordTitle: "lazy"))
        listOfWords.append(ReservedWord(wordTitle: "fileprivate"))
        listOfWords.append(ReservedWord(wordTitle: "extension"))
        listOfWords.append(ReservedWord(wordTitle: "dynamic"))
    }
    
    public func getList() -> [ReservedWord] {
        return listOfWords
    }
    
    public func setItemAsScored(at index: Int) {
        listOfWords[index].alreadyScored = true
    }
    
    public func getTotalScore() -> Int {
        return listOfWords.filter { $0.alreadyScored }.count
    }
    
    public func didUserScore(word: String) -> Bool {
        if let foundWord = listOfWords.first(where: { $0.wordTitle == word } ) {
            foundWord.alreadyScored = true
            return true
        } else {
            return false
        }
    }
}
