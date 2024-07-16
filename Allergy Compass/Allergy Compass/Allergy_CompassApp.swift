//
//  Allergy_Compass.swift
//  Allergy Compass Test 2
//
//  Created by iOS-Labor on 29.02.24.
//

import SwiftUI

@main
struct Allergy_Compass: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            PreMain()
                .environmentObject(Person())
                .environmentObject(tglBtnObj())
        }
    }
}
