//
//  Date+Extension.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 14/12/2023.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        return dateFormatter.string(from: self)
    }
}
