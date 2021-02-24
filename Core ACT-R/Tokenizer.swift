//
//  Tokenizer.swift
//  actr
//
//  Created by Niels Taatgen on 3/4/15.
//  Copyright (c) 2015 Niels Taatgen. All rights reserved.
//

import Foundation

class Tokenizer
{
    fileprivate var input:String
    
    var token:String?
    var c: Character?
    
    init (s: String) {
        input = s
        c = " "
        while (c != nil && (Tokenizer.isWhitespace(c!))) { nextChar() }
        nextToken()
    }
    
    fileprivate func nextChar() {
     //   println("\(input.isEmpty)")
        if input.isEmpty {
          c = nil }
        else {
        c = input[input.startIndex]
            input = input.substring(from: 1)
            print(c!, terminator: "")
        }
    }
    
    class func isWhitespace(_ c: Character) -> Bool {
        return (c==" " || c=="\n" || c=="\r" || c=="\t")
    }
    
    func nextToken()  {
        if (c == nil) {
            token = nil
            return
        }
        token = ""
        /// First handle comments
        while (c != nil && (c! == ";" || c! == "#")) {
            if (c==";") {
                while (c != nil && c! != "\n" && c! != "\r") { nextChar() }
            } else if (c! == "#") {
                if (c != nil) { nextChar() } // "#"
                if (c != nil) { nextChar() } // "|"
                while (c != nil && c! != "|") { nextChar() }
                if (c != nil) { nextChar() } // "|"
                if (c != nil) { nextChar() } // "#"
                
            }
            while (c != nil && (Tokenizer.isWhitespace(c!))) { nextChar() }
        }
        if (c != nil && (c! == "(" || c! == ")")) {
             token = String(c!)
             nextChar()
        } else {
            while (c != nil && !(Tokenizer.isWhitespace(c!)) && !(c! == "(" || c! == ")")) {
            token! += String(c!)
            nextChar()
            }
        }
        while (c != nil && (Tokenizer.isWhitespace(c!))) { nextChar() }
    }
}
