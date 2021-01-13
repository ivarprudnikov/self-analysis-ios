import SwiftUI

struct AppSidebarNavigation: View {
    enum NavigationItem {
        case assessments
        case about
    }
    @EnvironmentObject private var state: AppState
    @State private var selection: NavigationItem? = .assessments
    
    var body: some View {
        NavigationView {
            sidebar
            
            Text("Select a category")
                .foregroundColor(.secondary)
            
            Text("Select a smoothie")
                .foregroundColor(.secondary)
                .toolbar {
                    SmoothieFavoriteButton(smoothie: nil)
                        .disabled(true)
                }
        }
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
    }
}
