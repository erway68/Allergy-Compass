//
//  ThemeManager.swift
//  Allergy Compass
//
//  Created by iOS-Labor on 29.02.24.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {}
    
    func handleTheme(system: Bool){
        guard !system else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            return
        }
        
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = system ? .dark : .light
    }
}
