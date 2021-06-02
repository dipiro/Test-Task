//
//  ConsoleIO.swift
//  Task 1
//
//  Created by piro on 30.05.21.
//

import Foundation

class Message {
    func repeatFunc() {
        
        print("Ещё раз? 'yes' для повтора, 'no' для выхода ")
        
        var rep = false
        
        while !rep {
            let a = readLine()
            
            if a == "yes" {
                Start().start()
                print("Ещё раз? 'yes' для повтора, 'no' для выхода ")
            } else if a == "no" {
                rep = true
            } else {
                print("Команда не распознана, 'yes' для повтора, 'no' для выхода")
            }
        }
    }
}
