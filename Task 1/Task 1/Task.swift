//
//  func.swift
//  Task 1
//
//  Created by piro on 30.05.21.
//

import Foundation

class Task {
    
    private func checkingForEmptyValue(_ a: String?, _ b: String?, _ c: String?) -> (a: String, b: String, c: String) {
        var A = "100"
        var B = "200"
        var C = "300"
        
        if a != "" {
            A = a!
        }
        
        if b != "" {
            B = b!
        }
        
        if c != "" {
            C = c!
        }
        
        return (A, B, C)
    }
    
    func quadraticEquation(_ a: String?, _ b: String?, _ c: String?) -> String {
        
        let (A, B, C) = checkingForEmptyValue(a, b, c)
        
        guard let a = Float(A),
              let b = Float(B),
              let c = Float(C) else { return "Пожалуйсте, введите корректное значение" }
        
        let D = pow(b, 2) - 4 * a * c
        var X1 = ""
        var X2 = ""
        
        if D < 0 {
            return "Дискриминант = \(D), корней нет"
            
        } else if D == 0 {
            X1 = String((-b + sqrt(D)) / (2 * a))
            
            return "Дискриминант = \(D), X1 = \(X1)"
        } else {
            X1 = String((-b + sqrt(D)) / (2 * a))
            X2 = String((-b - sqrt(D)) / (2 * a))
            
            return "Дискриминант = \(D), X1 = \(X1), X2 = \(X2)"
        }
    }
    
}

