//
//  Date+Extension.swift
//  ToDoApp
//
//  Created by saurav sinha on 12/08/23.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let lDateformatter = DateFormatter()
        lDateformatter.dateStyle = .short
        lDateformatter.timeStyle = .short
        
        return lDateformatter.string(from: self)
    }
}
