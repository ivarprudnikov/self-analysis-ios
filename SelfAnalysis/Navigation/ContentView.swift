//
//  ContentView.swift
//  SelfAnalysis
//
//  Created by Aivaras Prudnikovas on 13/01/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var body: some View {
        AppTabNavigation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
