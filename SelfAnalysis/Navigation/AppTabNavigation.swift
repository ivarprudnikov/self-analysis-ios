import SwiftUI

struct AppTabNavigation: View {
    @State private var selection: Tab = .assessments
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                AssessmentsList()
            }
            .tabItem {
                Label("Assessments", systemImage: "list.bullet")
                    .accessibility(label: Text("Assessments"))
            }
            .tag(Tab.assessments)
            NavigationView {
                About()
            }
            .tabItem {
                Label("About", systemImage: "book.closed")
                    .accessibility(label: Text("About"))
            }
            .tag(Tab.about)
        }
    }
}

extension AppTabNavigation {
    enum Tab {
        case assessments
        case about
    }
}

// MARK: - Previews

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}

