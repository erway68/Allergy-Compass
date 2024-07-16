//
//  Main.swift
//  Allergy Compass Test 2
//
//  Created by iOS-Labor on 29.02.24.
//

import SwiftUI

/// A view representing the main screen of the application
struct Main: View {
    
    /// Binding to the navigation path
    @Binding var path: NavigationPath
    
    /// Enumeration defining different tabs in the main view
    enum Tab {
        case preMain, firstSelection, historyView, main
    }
    
    /// The currently selected tab
    @State private var selectedTab: Tab = .preMain
    
    var body: some View {
        
        // TabView to display different screens based on selectedTab
        TabView(selection: $selectedTab){
            
            // FirstSelection view
            FirstSelection(path: $path)
                .tabItem { Label("Profile", systemImage: "person") } 
                .tag(Tab.firstSelection)
            
            // HistoryView view
            HistoryView(path: $path)
                .tabItem { Label("History", systemImage: "clock") }
                .tag(Tab.historyView)
                .badge(10)
                
        }
        .accentColor(.black)
        .environmentObject(Person()) // Inject Person object into environment
        .environmentObject(tglBtnObj()) // Inject tglBtnObj object into environment
        
    }
}

