//
//  ContentView.swift
//  SelfAnalysis
//
//  Created by Aivaras Prudnikovas on 13/01/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        AppTabNavigation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
