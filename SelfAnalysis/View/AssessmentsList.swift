import SwiftUI
import CoreData

struct AssessmentsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Assessment.entity(), sortDescriptors: []) var assessments: FetchedResults<Assessment>
    @State var showNewAssessmentSheet = false

    var body: some View {
        List {
            ForEach(self.assessments) { assessment in
                AssessmentRow(assessment: assessment)
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
        .navigationBarItems(trailing: Button(action: {
            showNewAssessmentSheet = true
        }, label: {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        }))
        .overlay(Group {
            if self.assessments.isEmpty {
                Text("What are you waiting for?")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        })
        .sheet(isPresented: $showNewAssessmentSheet) {
            CreateAssessmentSheet()
        }
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
