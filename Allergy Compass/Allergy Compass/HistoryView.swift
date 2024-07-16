//
//  HistoryView.swift
//  Allergy Compass Test 2
//
//  Created by iOS-Labor on 29.02.24.
//

import SwiftUI
import CoreData

/// View model responsible for managing Core Data operations related to allergy history
class CoreDataViewModel: ObservableObject {
    
    /// Core Data persistent container.
    let container: NSPersistentContainer
    
    /// Published array containing allergy history
    @Published var allergyHistory: [AllergyEntity] = []
    
    /// Initializes the Core Data ViewModel
    init() {
        container = NSPersistentContainer(name: "Allergy Compass Database")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error Core Data \(error)")
            } else {
                print("Successfully loaded Core Data")
            }
        }
        fetchAllergy()
    }
    
    /// Fetches allergy history from Core Data
    func fetchAllergy() {
        let request = NSFetchRequest<AllergyEntity>(entityName: "AllergyEntity")
        
        do {
            allergyHistory = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error)")
        }
    }
    
    /// Adds a new allergy entry to Core Data
    func addAllergy(text: String) {
        let newAllergy = AllergyEntity(context: container.viewContext)
        newAllergy.name = text
        saveData()
    }
    
    /// Saves data changes to Core Data
    func saveData() {
        do {
            try container.viewContext.save()
            fetchAllergy()
        } catch let error {
            print("Error saving \(error)")
        }
    }
    
    /// Deletes an allergy entry from Core Data
    func deleteAllergy(indexSet: IndexSet) {
        guard let i = indexSet.first
        else {
            return
        }
        let allergy = allergyHistory[i]
        container.viewContext.delete(allergy)
        saveData()
    }
}

/// View displaying the history of allergies and allowing users to add new entries
struct HistoryView: View {
    
    /// View model for managing Core Data operations
    @StateObject var vm = CoreDataViewModel()
    @Binding var path: NavigationPath
    @AppStorage("tfUserInput") var tfUserInput = ""
    @EnvironmentObject var allergicTo: tglBtnObj
    
    @State private var showAlert = false
    @State private var allergicToItem = false
    @State private var isPresented = false
    
    /// Adds a new entry to the history list
    func addNewAllergy() {
        if(tfUserInput.isEmpty) {
            isPresented = true
            return
        }
        vm.addAllergy(text: tfUserInput)
    }
    
    /// Checks if the user is allergic to the entered item.
    private func checkAllergy() {
        // Convert user input to lowercase for case-insensitive comparison
        let userInputLowercased = tfUserInput.lowercased()
        
        // Array containing tuples of allergy toggle states and corresponding keywords
        let allergies: [(toggle: Bool, keyword: String)] = [
            (allergicTo.toggleGluten,        "gluten"),
            (allergicTo.toggleDairy,         "dairy"),
            (allergicTo.toggleCelery,        "celery"),
            (allergicTo.toggleFruits,        "fruits"),
            (allergicTo.togglePeanut,        "peanut"),
            (allergicTo.toggleSesame,        "sesame"),
            (allergicTo.toggleSoybean,       "soybean"),
            (allergicTo.toggleTreeNuts,      "treenuts"),
            (allergicTo.toggleChickenEgg,    "chicken egg"),
            (allergicTo.toggleFishShellfish, "fish")]
        
        // Iterate through the allergies array to check if any toggle is true and the keyword is present in the user input
        for (toggle, keyword) in allergies {
            if toggle && tfUserInput.localizedCaseInsensitiveContains(keyword) {
                allergicToItem = true
                showAlert = true
                return
            }
        }
        
        // If no match is found, set allergicToItem to false and show the alert
        allergicToItem = false
        showAlert = true
    }
    
    /// View displaying the history of allergies and allowing users to add new entries.
    var body: some View {
        GeometryReader { proxy in
            HStack {
                VStack {
                    
                    // List showing allergy history
                    List {
                        ForEach(vm.allergyHistory) { allergy in
                            Text(allergy.name ?? "no entry")
                        }
                        .onDelete(perform: vm.deleteAllergy)
                    }
                    TextField("What's on your mind?", text: $tfUserInput)
                        .padding(.top)
                        .frame(width: 230)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Check") {
                        if tfUserInput.isEmpty {
                            isPresented = true
                        } else {
                            addNewAllergy()
                            checkAllergy()
                            tfUserInput.removeAll()
                        }
                    }
                    .padding(.all)
                    
                    // Alert for empty input
                    .alert(isPresented: $isPresented) {
                        Alert(title: Text("Error"),
                              message: Text("Please enter something!"),
                              dismissButton: .default(Text("OK")))
                    }
                    
                    // Alert for allergy warning
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Allergy Warning"),
                              message: Text(allergicToItem ? "You can't eat this product." : "You can eat this product. Enjoy your meal!"),
                              dismissButton: .default(Text("OK")))
                    }
                }
            }
            .environmentObject(Person())
            .environmentObject(tglBtnObj())
        }
        .background(Gradient(colors: [.teal, .cyan, .green]))
        .opacity(0.5)
        .animation(.linear)
    }
}

