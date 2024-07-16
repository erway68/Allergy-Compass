//
//  PreMain.swift
//  Allergy Compass Test 2
//
//  Created by iOS-Labor on 29.02.24.
//

import SwiftUI

/// A class representing a person object in the app
class Person : ObservableObject{
    @AppStorage("settedName") var settedName : String = ""
   
}

/// A view representing the pre-main screen for setting up a user profile
struct PreMain: View {
    
    /// Navigates to the main screen based on a boolean value
    /// - Parameter x: A boolean value indicating whether to navigate to the main screen
    func goToMain(x: Bool){
        if (x == true){
            path.append(2)
        } else {
            skipToMain = true
        }
    }
    
    /// The navigation path throughout the app
    @State private var path: NavigationPath = NavigationPath()
    // The text field storing the user's name
    @State var tfStorName: String = ""
    /// A boolean value indicating if an alert is presented
    @State var isPresented = false
    /// A boolean value indicating if navigation is triggered
    @State var navigate = false

    /// The person object managing user information.
    @EnvironmentObject var person: Person
    
    /// A boolean value indicating if the name is set.
    @AppStorage("settedName") var setName = false
    /// A boolean value indicating if the name button is set.
    @AppStorage("settedNameButton") var setNameButton = false
    /// A boolean value indicating if navigation should skip to the main screen.
    @AppStorage("settedFirstView") var skipToMain = false
    
    var body: some View {
        NavigationStack(path: $path) {
            
            VStack{
                
                GeometryReader { proxy in
                    
                    // Display a welcome message with the user's name
                    Text("Willkommen \(person.settedName), bitte erstelle ein Profil um fortzufahren")
                        .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 1)
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.largeTitle)
                        .animation(.easeOut(duration: 1))
                    
                }.onAppear(perform: {
                    goToMain(x: skipToMain)
                })
                
                VStack{
                    
                    // Text field to input user's first name
                    TextField("Vorname", text: $tfStorName)
                        .frame(width: 200)
                        .background(.white)
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder).cornerRadius(10)
                       
                    Spacer()
                    
                    HStack{
                        
                        // Button to continue to the next screen
                        Text("Continue")
                            .onTapGesture {
                                if (tfStorName.isEmpty){
                                    isPresented = true
                                } else {
                                    
                                    // Save the user's name and navigate to the next screen
                                    person.settedName = tfStorName
                                    setNameButton = true
                                    tfStorName.removeAll()
                                    navigate = true
                                
                                    path.append(1)
                                    
                                }
                            }.alert(isPresented: $isPresented){
                                // Alert to prompt user to enter their name
                                Alert(title: Text("Error!"),
                                      message: Text("Please enter your name!"),
                                      dismissButton: .default(Text("OK")))}
                       
                            .buttonStyle(BorderedButtonStyle())
                            .tint(.white.opacity(17))
                            .foregroundColor(.black)
                            .padding()
                        
                    }
                }
                // Apply background gradient and opacity
                .navigationDestination(for: Int.self, destination: { value in
                    switch value {
                    case 1 :
                        // Navigate to the first selection screen
                        FirstSelection(path: $path)
                            .navigationBarBackButtonHidden(true)
                    case 2 :
                        // Navigate to the main screen
                        Main(path: $path)
                            .navigationBarBackButtonHidden(true)
                    default:
                        PreMain()
                    }
                })
            }.background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.6)).opacity(0.8)
            
            
        }
        .environmentObject(Person())
        .environmentObject(tglBtnObj())
    }
}

