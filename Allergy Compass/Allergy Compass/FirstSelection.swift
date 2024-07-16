//
//  FirstSelection.swift
//  Allergy Compass Test 2
//
//  Created by iOS-Labor on 29.02.24.
//

import SwiftUI

/// An observable object managing toggle button states for allergies

class tglBtnObj : ObservableObject{
    @AppStorage("btnVisible") var btnVisible =                   true
    @AppStorage("textVisible") var textVisible =                 true

    @AppStorage("toggleGluten") var toggleGluten =               false
    @AppStorage("toggleCelery") var toggleCelery =               false
    @AppStorage("toggleChickenEgg") var toggleChickenEgg =       false
    @AppStorage("toggleDairy") var toggleDairy =                 false
    @AppStorage("toggleFishShellfish") var toggleFishShellfish = false
    @AppStorage("toggleFruits") var toggleFruits =               false
    @AppStorage("togglePeanut") var togglePeanut =               false
    @AppStorage("toggleSesame") var toggleSesame =               false
    @AppStorage("toggleSoybean") var toggleSoybean =             false
    @AppStorage("toggleTreeNuts") var toggleTreeNuts =           false

}

/// A view representing the first selection screen where users can choose their allergies
///
struct FirstSelection: View {
    
    /// Binding to the navigation path
    @Binding var path: NavigationPath
        
    /// The person object managing user information
    @EnvironmentObject var person: Person
    /// The toggle button object managing toggle states
    @EnvironmentObject var tglObj: tglBtnObj
        
    /// A boolean value indicating if the Weiter button is pressed
    @AppStorage("btnWeiterBool") private var btnWeiter = false
    
    var body: some View {
        
        VStack{
            GeometryReader { proxy in
                
                // Display text based on toggle visibility
                if tglObj.textVisible {
                    Text("Hallo \(person.settedName), bitte wähle deine Allergien aus um fortzufahren")
                        .multilineTextAlignment(.center)
                        .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 1)
                        .padding()
                        .font(.largeTitle)
                    
                } else {
                    Text("Hallo \(person.settedName), hier kannst du Allergien an- und abwählen.")
                        .multilineTextAlignment(.center)
                        .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 1)
                        .padding()
                        .font(.largeTitle)
                }
                Spacer(minLength: 20)
                
            }
            
            GeometryReader{ proxy in
                VStack{
                
                    // Toggle buttons for each allergy
                    Toggle(isOn: $tglObj.toggleGluten) {
                        Text("🌾  Gluten")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleCelery) {
                        Text("🥬  Celery")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleChickenEgg) {
                        Text("🥚  ChickenEgg")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleDairy) {
                        Text("🥛  Dairy")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleFishShellfish) {
                        Text("🐟  Fish and Shellfish")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleFruits) {
                        Text("🍌  Fruits")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.togglePeanut) {
                        Text("🥜  Peanut")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleSesame) {
                        Text("🫘  Sesame")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleSoybean) {
                        Text("🫛  Soybean")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    Toggle(isOn: $tglObj.toggleTreeNuts) {
                        Text("🌰  Tree nuts")}.frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.1)
                    
                }.padding(.all).frame(width: proxy.size.width * 1, height: proxy.size.height * 1)
                
            }
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            HStack{
                if tglObj.btnVisible{
                    Text("Weiter")
                        .onTapGesture {
                            path.append(2)
                            tglObj.btnVisible = false
                            tglObj.textVisible = false
                            
                        }
                }

            }
            
        }.background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.6)).opacity(0.8)
        
        .environmentObject(Person())
        .environmentObject(tglBtnObj())
    }
}

