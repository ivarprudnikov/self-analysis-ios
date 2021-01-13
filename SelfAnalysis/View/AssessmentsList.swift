import SwiftUI

struct AssessmentsList: View {
    @EnvironmentObject private var state: AppState
    @State private var selection: Assessment?

    var body: some View {
        List(selection: $selection) {
            ForEach(state.assessments) { assessment in
                AssessmentRow(assessment: assessment)
            }
        }
    }
}

struct AssessmentsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AssessmentsList()
                    .navigationTitle("Home")
                    .environmentObject(AppState().addAssessment(Assessment(id:1))
                        .addAssessment(Assessment(id:2)))
            }
            .preferredColorScheme(scheme)
        }
    }
}
