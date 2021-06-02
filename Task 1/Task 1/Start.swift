//
//  Start.swift
//  Task 1
//
//  Created by piro on 30.05.21.
//

import Foundation

class Start {
    
    func start() {
        print("Введите значение первого аргумента")
        let a = readLine()
        print("Введите значение второго аргумента")
        let b = readLine()
        print("Введите значение третьего аргумента")
        let c = readLine()
        
        let result = task.quadraticEquation(a, b, c)
        print("Результат равен - \(result)")
    }
}
