import SwiftUI
import CoreData

struct AssessmentsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Assessment.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \Assessment.createdAt, ascending: false)
    ]) var assessments: FetchedResults<Assessment>
    
    @State private var selection: Assessment?

    var body: some View {
        List(selection: $selection) {
            ForEach(self.assessments) { assessment in
                NavigationLink(
                    destination: AssessmentForm(assessmentId: assessment.id!),
                    tag: assessment,
                    selection: $selection
                ){
                    AssessmentRow(assessment: assessment)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let item = assessments[index]
                    viewContext.delete(item)
                    do {
                        try viewContext.save()
                    } catch let error {
                        print("Error: \(error)")
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Assessments")
        .navigationBarItems(trailing: AsyncAddAssessmentButton())
        .overlay(Group {
            if self.assessments.isEmpty {
                Text("Your assessments will appear here, please create one first.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(32)
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
