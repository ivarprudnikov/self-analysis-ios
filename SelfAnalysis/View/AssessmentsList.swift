import SwiftUI
import CoreData

struct AssessmentsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Assessment.entity(), sortDescriptors: []) var assessments: FetchedResults<Assessment>

    var body: some View {
        List {
            ForEach(self.assessments) { assessment in
                AssessmentRow(assessment: assessment)
            }
        }
        .listStyle(PlainListStyle())
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
        .overlay(Group {
            if self.assessments.isEmpty {
                Text("What are you waiting for?")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        })
    }
}

struct AssessmentsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AssessmentsList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
            .preferredColorScheme(scheme)
        }
    }
}
