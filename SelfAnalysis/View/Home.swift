import SwiftUI

struct Home: View {
    @EnvironmentObject private var state: AppState
    var body: some View {
        AssessmentsList()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(AppState())
    }
}
