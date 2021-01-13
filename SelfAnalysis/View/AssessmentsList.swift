import SwiftUI

struct AssessmentsList: View {
    @EnvironmentObject private var state: AppState
    @State private var selection: Assessment?

    var body: some View {
        Group {
            if state.assessments.isEmpty {
                Text("What are you waiting for?")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selection) {
                    ForEach(state.assessments) { assessment in
                        AssessmentRow(assessment: assessment)
                    }
                }
            }
        }
        .navigationTitle("Assessments")
        .navigationBarItems(
            trailing:
                Button(action: {
                    print("Add button tapped!")
                }) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
        )
    }
}

struct AssessmentsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AssessmentsList()
                    .environmentObject(AppState())
            }
            .preferredColorScheme(scheme)
        }
    }
}
