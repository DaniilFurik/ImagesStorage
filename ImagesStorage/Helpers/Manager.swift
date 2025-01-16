//
//  Manager.swift
//  Racing2D
//
//  Created by Даниил on 26.11.24.
//

import Foundation
import UIKit

final class Manager {
    // MARK: - Properties
    
    static let shared = Manager()
    
    private init() { }
}

extension Manager {
    // MARK: - Methods
    
    func getFormattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = GlobalConstants.dateFormat
        return formatter.string(from: date)
    }
    
    func getDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = GlobalConstants.dateFormat
        return formatter.date(from: string)
    }
}
